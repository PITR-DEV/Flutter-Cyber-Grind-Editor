import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/models/grid_block.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateController getGridBlockNotifier(
  ComponentRef ref,
  int x,
  int y,
) {
  return ref.read(gridProvider(x * ParsingHelper.arenaSize + y).notifier);
}

int gridHeightLimiter(int value) {
  if (value > 50) return 50;
  if (value < -50) return -50;
  return value;
}

List<List<Cell>> getGrid(ComponentRef ref) {
  final grid = <List<Cell>>[];
  for (int x = 0; x < ParsingHelper.arenaSize; x++) {
    final row = <Cell>[];
    for (int y = 0; y < ParsingHelper.arenaSize; y++) {
      row.add(ref.read(gridProvider(x * ParsingHelper.arenaSize + y)));
    }
    grid.add(row);
  }
  return grid;
}
