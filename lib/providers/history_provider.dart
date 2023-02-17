import 'package:cgef/models/history_item.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyProvider =
    StateProvider<IList<HistoryEvent>>((ref) => <HistoryEvent>[].lock);
final redoHistoryProvider =
    StateProvider<IList<HistoryEvent>>((ref) => <HistoryEvent>[].lock);

void invalidateRedoHistory(ComponentRef ref) {
  ref.read(redoHistoryProvider.notifier).state = <HistoryEvent>[].lock;
}

void undo(WidgetRef ref) {
  final historyItem = ref.read(historyProvider).last;

  // push into the redo history
  ref.read(redoHistoryProvider.notifier).state =
      ref.read(redoHistoryProvider.notifier).state.add(historyItem);

  ref.read(historyProvider.notifier).state =
      ref.read(historyProvider.notifier).state.removeLast();

  applyDeltas(historyItem, ref, actionUndo: false);
}

void redo(WidgetRef ref) {
  final historyItem = ref.read(redoHistoryProvider).last;

  // push into the undo history
  ref.read(historyProvider.notifier).state =
      ref.read(historyProvider.notifier).state.add(historyItem);

  ref.read(redoHistoryProvider.notifier).state =
      ref.read(redoHistoryProvider.notifier).state.removeLast();

  applyDeltas(historyItem, ref, actionUndo: true);
}

void applyDeltas(HistoryEvent event, WidgetRef ref,
    {required bool actionUndo}) {
  for (var index in event.deltas.keys) {
    if (actionUndo) {
      ref.read(gridProvider(index).notifier).state =
          event.deltas[index]!.newState;
    } else {
      ref.read(gridProvider(index).notifier).state =
          event.deltas[index]!.oldState;
    }
  }
}
