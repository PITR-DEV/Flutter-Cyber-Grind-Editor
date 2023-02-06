import 'package:cgef/helpers/grid_helper.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/models/grid_block.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/models/enums.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gridProvider = StateProvider.family<GridBlock, int>(
  (ref, index) {
    return GridBlock(height: 0, prefab: '0', index: index);
  },
);

final hoveredProvider = StateProvider((ref) => <int>[].lock);
final paintedOverProvider = StateProvider((ref) => <int>[].lock);

final isPaintingProvider = StateProvider((ref) => false);

void resetPattern(WidgetRef ref) {
  // Reset all state
  for (int i = 0; i < ParsingHelper.arenaSize * ParsingHelper.arenaSize; i++) {
    ref.read(gridProvider(i).notifier).state = GridBlock(
      height: 0,
      prefab: '0',
      index: i,
    );
  }
  ref.read(paintedOverProvider.notifier).state = <int>[].lock;
  ref.read(hoveredProvider.notifier).state = <int>[].lock;
}

void loadFromString(WidgetRef ref, String source) {
  // Load a pattern from a string
  final grid = ParsingHelper().importString(source);
  for (int i = 0; i < ParsingHelper.arenaSize * ParsingHelper.arenaSize; i++) {
    final y = i ~/ ParsingHelper.arenaSize;
    final x = i % ParsingHelper.arenaSize;
    ref.read(gridProvider(i).notifier).state = grid[x][y];
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

  final relevantBlocks = <GridBlock>[];
  for (int x = x1; x <= x2; x++) {
    for (int y = y1; y <= y2; y++) {
      relevantBlocks.add(getGridBlockNotifier(ref, x, y).state);
    }
  }
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

  final relevantBlocks = <GridBlock>[];
  for (int x = x1; x <= x2; x++) {
    relevantBlocks.add(getGridBlockNotifier(ref, x, y1).state);
    relevantBlocks.add(getGridBlockNotifier(ref, x, y2).state);
  }
  for (int y = y1; y <= y2; y++) {
    relevantBlocks.add(getGridBlockNotifier(ref, x1, y).state);
    relevantBlocks.add(getGridBlockNotifier(ref, x2, y).state);
  }
  return relevantBlocks.map((e) => e.index).toList();
}

void onClickBlock(ComponentRef ref, int index) {
  // When a block is clicked
  final toolSelected = ref.read(selectedGridBlockProvider);
  final x = index % ParsingHelper.arenaSize;
  final y = index ~/ ParsingHelper.arenaSize;

  switch (ref.read(toolProvider)) {
    case Tool.point:
    case Tool.brush:
      affectBlock(ref, index);
      break;
    case Tool.fillRect:
      if (toolSelected == null) {
        ref.read(selectedGridBlockProvider.notifier).state =
            index % ParsingHelper.arenaSize +
                (index ~/ ParsingHelper.arenaSize) * ParsingHelper.arenaSize;
        hoverOverBlock(ref, index);
      } else {
        computeFill(ref, x, y, toolSelected % ParsingHelper.arenaSize,
                toolSelected ~/ ParsingHelper.arenaSize)
            .forEach((index) {
          affectBlock(ref, index);
        });
        ref.read(selectedGridBlockProvider.notifier).state = null;
        resetHover(ref);
      }
      break;
    case Tool.outlineRect:
      if (toolSelected == null) {
        ref.read(selectedGridBlockProvider.notifier).state = index;
        hoverOverBlock(ref, index);
      } else {
        computeRectOutline(ref, x, y, toolSelected % ParsingHelper.arenaSize,
                toolSelected ~/ ParsingHelper.arenaSize)
            .forEach((index) {
          affectBlock(ref, index);
        });
        ref.read(selectedGridBlockProvider.notifier).state = null;
        resetHover(ref);
      }
      break;
  }
}

// This function is called when a block is clicked in the grid. It determines
// which prefab is active, and if it's a prefab, it sets the prefab of the
// clicked block to that prefab. If it's a tool, it uses the tool modifier
// and the tool value to modify the block's height.
//
// Parameters:
// - ref: The WidgetRef of the widget that called the function
// - x: The x coordinate of the block in the grid
// - y: The y coordinate of the block in the grid

void affectBlock(ComponentRef ref, int index) {
  final activeTab = ref.read(tabProvider);
  final x = index ~/ ParsingHelper.arenaSize;
  final y = index % ParsingHelper.arenaSize;
  final gridElement = getGridBlockNotifier(ref, x, y);

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
    return;
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
}

void hoverOverBlock(ComponentRef ref, int index) {
  final selectedBlock = ref.read(selectedGridBlockProvider);
  final currentTool = ref.read(toolProvider);
  final isPainting = ref.read(isPaintingProvider);

  if (currentTool != Tool.brush || !isPainting) resetHover(ref);
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

      for (var index in relevantBlocks) {
        setHover(ref, index, heavy: true);
      }
      break;
    case Tool.point:
      break;
  }
}

void paintStart(ComponentRef ref) {
  if (ref.read(toolProvider) != Tool.brush) return;

  ref.read(isPaintingProvider.notifier).state = true;

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
  resetHover(ref);
}

void computePaint(ComponentRef ref) {
  if (!ref.read(isPaintingProvider)) return;

  final paintedNotif = ref.read(paintedOverProvider.notifier);

  for (var index in ref.read(hoveredProvider)) {
    if (paintedNotif.state.contains(index)) continue;

    affectBlock(
      ref,
      index,
    );
    paintedNotif.state = paintedNotif.state.add(index);
  }
}

void resetHover(ComponentRef ref) {
  ref.read(hoveredProvider.notifier).state = ref.read(hoveredProvider).clear();
  ref.read(paintedOverProvider.notifier).state =
      ref.read(paintedOverProvider).clear();
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
  ref.read(hoveredProvider.notifier).state =
      ref.read(hoveredProvider).add(x + y * ParsingHelper.arenaSize);
  // print('hovered: $x, $y');
}
