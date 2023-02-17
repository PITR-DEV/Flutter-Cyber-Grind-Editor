import 'package:cgef/helpers/grid_helper.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/models/grid_block.dart';
import 'package:cgef/models/history_item.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/history_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gridProvider = StateProvider.family<Cell, int>(
  (ref, index) {
    return Cell(
      height: 0,
      prefab: '0',
      index: index,
    );
  },
);

final cellStates = StateProvider.family<CellState, int>(
  (ref, index) {
    return const CellState(
      isHovered: false,
      isPaintedOver: false,
    );
  },
);

void resetVolatileState(WidgetRef ref) {
  ref.read(hoveredProvider.notifier).state = <int>[].lock;
  ref.read(paintedOverProvider.notifier).state = <int>[].lock;
  ref.read(isPaintingProvider.notifier).state = false;
  for (int i = 0; i < ParsingHelper.arenaSize * ParsingHelper.arenaSize; i++) {
    ref.read(cellStates(i).notifier).state = const CellState(
      isHovered: false,
      isPaintedOver: false,
    );
  }
}

final hoveredProvider = StateProvider((ref) => <int>[].lock);
final paintedOverProvider = StateProvider((ref) => <int>[].lock);
final paintDeltas = StateProvider((ref) => <Delta>[].lock);
final isPaintingProvider = StateProvider((ref) => false);

void newPattern(WidgetRef ref) {
  ref.read(pastHomeProvider.notifier).state = true;
  resetPattern(ref);
}

void resetPattern(WidgetRef ref) {
  // Reset all state
  for (int i = 0; i < ParsingHelper.arenaSize * ParsingHelper.arenaSize; i++) {
    ref.read(gridProvider(i).notifier).state = Cell(
      height: 0,
      prefab: '0',
      index: i,
    );
    ref.read(cellStates(i).notifier).state = const CellState(
      isHovered: false,
      isPaintedOver: false,
    );
  }
  ref.read(paintedOverProvider.notifier).state = <int>[].lock;
  ref.read(hoveredProvider.notifier).state = <int>[].lock;
  ref.read(isPaintingProvider.notifier).state = false;

  ref.read(historyProvider.notifier).state = <HistoryEvent>[].lock;
  ref.read(redoHistoryProvider.notifier).state = <HistoryEvent>[].lock;
}

void loadFromString(WidgetRef ref, String source) {
  // Load a pattern from a string
  final grid = ParsingHelper().importString(source);
  for (int i = 0; i < ParsingHelper.arenaSize * ParsingHelper.arenaSize; i++) {
    final y = i ~/ ParsingHelper.arenaSize;
    final x = i % ParsingHelper.arenaSize;
    ref.read(gridProvider(i).notifier).state = grid[x][y];
    ref.read(cellStates(i).notifier).state = const CellState(
      isHovered: false,
      isPaintedOver: false,
    );
    ref.read(historyProvider.notifier).state = <HistoryEvent>[].lock;
    ref.read(redoHistoryProvider.notifier).state = <HistoryEvent>[].lock;
    resetVolatileState(ref);
  }
}

List<int> computeFill(ComponentRef ref, int x1, int y1, int x2, int y2) {
  // Compute the fill of a rectangle
  if (x1 > x2) {
    final temp = x1;
    x1 = x2;
    x2 = temp;
  }
  if (y1 > y2) {
    final temp = y1;
    y1 = y2;
    y2 = temp;
  }

  final relevantBlocks = <Cell>[];
  for (int x = x1; x <= x2; x++) {
    for (int y = y1; y <= y2; y++) {
      relevantBlocks.add(getGridBlockNotifier(ref, y, x).state);
    }
  }
  relevantBlocks.removeDuplicates();
  return relevantBlocks.map((e) => e.index).toList();
}

List<int> computeRectOutline(ComponentRef ref, int x1, int y1, int x2, int y2) {
  // Compute the outline of a rectangle
  if (x1 > x2) {
    final temp = x1;
    x1 = x2;
    x2 = temp;
  }
  if (y1 > y2) {
    final temp = y1;
    y1 = y2;
    y2 = temp;
  }

  final relevantBlocks = <Cell>[];
  for (int x = x1; x <= x2; x++) {
    relevantBlocks.add(getGridBlockNotifier(ref, y1, x).state);
    relevantBlocks.add(getGridBlockNotifier(ref, y2, x).state);
  }
  for (int y = y1; y <= y2; y++) {
    relevantBlocks.add(getGridBlockNotifier(ref, y, x1).state);
    relevantBlocks.add(getGridBlockNotifier(ref, y, x2).state);
  }

  relevantBlocks.removeDuplicates();
  return relevantBlocks.map((e) => e.index).toList();
}

void toolChanged(ComponentRef ref) {
  // ref.read(paintedOverProvider.notifier).state = <int>[].lock;
  // ref.read(hoveredProvider.notifier).state = <int>[].lock;
  resetHover(ref);
  ref.read(selectedGridBlockProvider.notifier).state = null;
}

void onClickBlock(ComponentRef ref, int index) {
  // When a block is clicked
  final toolSelected = ref.read(selectedGridBlockProvider);
  final x = index % ParsingHelper.arenaSize;
  final y = index ~/ ParsingHelper.arenaSize;

  invalidateRedoHistory(ref);

  switch (ref.read(toolProvider)) {
    case Tool.point:
    case Tool.brush:
      affectBlock(ref, index, recordToHistory: true);
      break;
    case Tool.fillRect:
      if (toolSelected == null) {
        ref.read(selectedGridBlockProvider.notifier).state =
            index % ParsingHelper.arenaSize +
                (index ~/ ParsingHelper.arenaSize) * ParsingHelper.arenaSize;

        final cellStateNotifier = ref.read(cellStates(index).notifier);
        cellStateNotifier.state = cellStateNotifier.state
            .copyWith(isPaintedOver: true, isHovered: true);
      } else {
        var deltas = <Delta>[];

        for (var index in computeFill(
          ref,
          x,
          y,
          toolSelected % ParsingHelper.arenaSize,
          toolSelected ~/ ParsingHelper.arenaSize,
        )) {
          deltas.add(affectBlock(ref, index));
        }
        ref.read(selectedGridBlockProvider.notifier).state = null;
        resetHover(ref);

        ref.read(historyProvider.notifier).state =
            ref.read(historyProvider).add(HistoryEvent(
                  {for (var e in deltas) e.newState.index: e},
                ));
      }
      break;
    case Tool.outlineRect:
      if (toolSelected == null) {
        ref.read(selectedGridBlockProvider.notifier).state = index;
        // hoverOverBlock(ref, index);
        final cellStateNotifier = ref.read(cellStates(index).notifier);
        cellStateNotifier.state = cellStateNotifier.state
            .copyWith(isPaintedOver: true, isHovered: true);
      } else {
        var deltas = <Delta>[];

        computeRectOutline(ref, x, y, toolSelected % ParsingHelper.arenaSize,
                toolSelected ~/ ParsingHelper.arenaSize)
            .forEach((index) {
          deltas.add(affectBlock(ref, index));
        });
        ref.read(selectedGridBlockProvider.notifier).state = null;
        resetHover(ref);

        ref.read(historyProvider.notifier).state =
            ref.read(historyProvider).add(HistoryEvent(
                  {for (var e in deltas) e.newState.index: e},
                ));
      }
      break;
  }
}

Delta affectBlock(ComponentRef ref, int index, {bool recordToHistory = false}) {
  final activeTab = ref.read(tabProvider);
  final x = index ~/ ParsingHelper.arenaSize;
  final y = index % ParsingHelper.arenaSize;
  final gridElement = getGridBlockNotifier(ref, x, y);
  final originalState = gridElement.state;

  if (activeTab == AppTab.prefabs) {
    switch (ref.read(selectedPrefabProvider)) {
      case Prefab.none:
        gridElement.state = gridElement.state.copyWith(prefab: '0');
        break;
      case Prefab.melee:
        gridElement.state = gridElement.state.copyWith(prefab: 'n');
        break;
      case Prefab.projectile:
        gridElement.state = gridElement.state.copyWith(prefab: 'p');
        break;
      case Prefab.jumpPad:
        gridElement.state = gridElement.state.copyWith(prefab: 'J');
        break;
      case Prefab.stairs:
        gridElement.state = gridElement.state.copyWith(prefab: 's');
        break;
      case Prefab.hideous:
        gridElement.state = gridElement.state.copyWith(prefab: 'H');
        break;
    }
    final delta =
        Delta(gridElement.state, originalState, ref.read(toolProvider));
    if (recordToHistory) {
      ref.read(historyProvider.notifier).state = ref.read(historyProvider).add(
            HistoryEvent(
              {index: delta},
            ),
          );
    }
    return delta;
  }

  switch (ref.read(toolModifierProvider)) {
    case ToolModifier.plusOne:
      gridElement.state = gridElement.state
          .copyWith(height: gridHeightLimiter(gridElement.state.height + 1));
      break;
    case ToolModifier.minusOne:
      gridElement.state = gridElement.state
          .copyWith(height: gridHeightLimiter(gridElement.state.height - 1));
      break;
    case ToolModifier.setTo:
      gridElement.state = gridElement.state
          .copyWith(height: gridHeightLimiter(ref.read(setToValueProvider)));
      break;
    case ToolModifier.plusValue:
      gridElement.state = gridElement.state.copyWith(
          height: gridHeightLimiter(
              gridElement.state.height + ref.read(plusValueProvider)));
      break;
  }

  final delta = Delta(gridElement.state, originalState, ref.read(toolProvider));
  if (recordToHistory) {
    ref.read(historyProvider.notifier).state = ref.read(historyProvider).add(
          HistoryEvent(
            {index: delta},
          ),
        );
  }

  return delta;
}

void hoverOverBlock(ComponentRef ref, int index) {
  final selectedBlock = ref.read(selectedGridBlockProvider);
  final currentTool = ref.read(toolProvider);
  final isPainting = ref.read(isPaintingProvider);

  if (currentTool == Tool.point ||
      (currentTool == Tool.brush && !isPainting) ||
      (currentTool != Tool.brush && selectedBlock == null)) resetHover(ref);
  setHover(ref, index, heavy: currentTool == Tool.brush && isPainting);
  switch (currentTool) {
    case Tool.brush:
      computePaint(ref);
      break;
    case Tool.outlineRect:
    case Tool.fillRect:
      if (selectedBlock == null) {
        break;
      }

      var relevantBlocks = <int>[];
      final x = index % ParsingHelper.arenaSize;
      final y = index ~/ ParsingHelper.arenaSize;
      if (currentTool == Tool.fillRect) {
        relevantBlocks = computeFill(
            ref,
            x,
            y,
            selectedBlock % ParsingHelper.arenaSize,
            selectedBlock ~/ ParsingHelper.arenaSize);
      }
      if (currentTool == Tool.outlineRect) {
        relevantBlocks = computeRectOutline(
            ref,
            x,
            y,
            selectedBlock % ParsingHelper.arenaSize,
            selectedBlock ~/ ParsingHelper.arenaSize);
      }

      for (var index in ref
          .read(hoveredProvider)
          .where((element) => !relevantBlocks.contains(element))) {
        final cellStateNotifier = ref.read(cellStates(index).notifier);
        cellStateNotifier.state = cellStateNotifier.state
            .copyWith(isHovered: false, isPaintedOver: false);
        ref.read(hoveredProvider.notifier).state =
            ref.read(hoveredProvider).remove(index);
      }

      for (var index in relevantBlocks) {
        setHover(ref, index, heavy: true);
      }

      break;
    case Tool.point:
      break;
  }
}

void handleMouseDown(ComponentRef ref) {
  final currentTool = ref.read(toolProvider);
  final isPainting = ref.read(isPaintingProvider);

  if (currentTool == Tool.brush && !isPainting) {
    paintStart(ref);
  } else if (currentTool != Tool.brush) {
    ref.read(isClickPendingProvider.notifier).state = true;
  }
}

void handleMouseUp(ComponentRef ref) {
  final currentTool = ref.read(toolProvider);
  final isPainting = ref.read(isPaintingProvider);
  final selectedBlock = ref.read(hoveredCellIndexProvider);

  if (currentTool == Tool.brush && isPainting) {
    paintStop(ref);
  } else if (currentTool != Tool.brush) {
    if (selectedBlock != null && ref.read(isClickPendingProvider)) {
      onClickBlock(ref, selectedBlock);
      ref.read(isClickPendingProvider.notifier).state = false;
    }
  }
}

void cancelClick(ComponentRef ref) {
  ref.read(isClickPendingProvider.notifier).state = false;
}

void paintStart(ComponentRef ref) {
  if (ref.read(toolProvider) != Tool.brush) return;

  ref.read(isPaintingProvider.notifier).state = true;

  // create initial state. Mark first (starting) cell as painted over
  var indexes = List.from(ref.read(hoveredProvider));
  for (var index in indexes) {
    setHover(
      ref,
      index,
      heavy: true,
    );
  }

  computePaint(ref);
}

void paintStop(ComponentRef ref) {
  ref.read(isPaintingProvider.notifier).state = false;
  // commit to history
  ref.read(historyProvider.notifier).state = ref.read(historyProvider).add(
        HistoryEvent(
          {
            for (var delta in ref.read(paintDeltas)) delta.oldState.index: delta
          },
        ),
      );
  invalidateRedoHistory(ref);
  ref.read(paintDeltas.notifier).state = <Delta>[].lock;
  resetHover(ref);
}

void computePaint(ComponentRef ref) {
  if (!ref.read(isPaintingProvider)) return;

  final paintedNotif = ref.read(paintedOverProvider.notifier);

  for (var index in ref.read(hoveredProvider)) {
    if (paintedNotif.state.contains(index)) continue;

    var d = affectBlock(
      ref,
      index,
    );
    ref.read(paintDeltas.notifier).state = ref.read(paintDeltas).add(d);
    paintedNotif.state = paintedNotif.state.add(index);
  }
}

void resetHover(ComponentRef ref) {
  final hoveredNotifier = ref.read(hoveredProvider.notifier);
  for (var index in hoveredNotifier.state) {
    final cellStateNotifier = ref.read(cellStates(index).notifier);
    cellStateNotifier.state = cellStateNotifier.state
        .copyWith(isHovered: false, isPaintedOver: false);
  }

  ref.read(hoveredProvider.notifier).state = ref.read(hoveredProvider).clear();
  final selectedCell = ref.read(selectedGridBlockProvider);
  if (selectedCell != null) {
    final cellNotifier = gridProvider(selectedCell).notifier;
    ref.read(cellNotifier).state = ref.read(cellNotifier).state.copyWith();
  }

  ref.read(paintedOverProvider.notifier).state =
      ref.read(paintedOverProvider).clear();

  ref.read(isPaintingProvider.notifier).state = false;
}

void setHover(ComponentRef ref, int index, {bool heavy = false}) {
  final x = index % ParsingHelper.arenaSize;
  final y = index ~/ ParsingHelper.arenaSize;
  if (x < 0 ||
      x > ParsingHelper.arenaSize - 1 ||
      y < 0 ||
      y > ParsingHelper.arenaSize - 1) {
    return;
  }

  final hovered = ref.read(hoveredProvider);
  final cellStateNotifier = ref.read(cellStates(index).notifier);
  if (hovered.contains(index) &&
      !(heavy && !cellStateNotifier.state.isPaintedOver)) return;
  ref.read(hoveredProvider.notifier).state =
      ref.read(hoveredProvider).add(x + y * ParsingHelper.arenaSize);
  cellStateNotifier.state = cellStateNotifier.state.copyWith(
    isHovered: true,
    isPaintedOver: heavy,
  );
}
