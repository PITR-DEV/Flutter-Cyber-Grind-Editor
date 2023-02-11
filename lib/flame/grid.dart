
import 'package:cgef/flame/cell.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridGame extends FlameGame
    with HasTappables, HasComponentRef, HasGameRef {
  GridGame(WidgetRef ref) {
    HasComponentRef.widgetRef = ref;
  }

  List<GridBlockComponent> gridBlocks = [];
  int? hoveredIndex;
  bool clickCancelled = false;

  void updateCursorPosition(Offset offset) {
    final size = gameRef.size;
    // convert cursor x and y, into grid x and y and then into index
    final x = (offset.dx / size.x * ParsingHelper.arenaSize).floor();
    final y = (offset.dy / size.y * ParsingHelper.arenaSize).floor();
    final index = y * ParsingHelper.arenaSize + x;
    if (index == hoveredIndex) return;
    cancelClick(ref);
    ref.read(hoveredCellIndexProvider.notifier).state = index;
    hoverOverBlock(ref, index);
    hoveredIndex = index;
  }

  void resetClickCancelled() {
    clickCancelled = false;
  }

  @override
  onLoad() async {
    await super.onLoad();
    // create a components for all grid elements
  }

  @override
  void onMount() {
    super.onMount();
    const total = ParsingHelper.arenaSize * ParsingHelper.arenaSize;
    for (var i = 0; i < total; i++) {
      final cell = GridBlockComponent(i);
      add(cell);
      gridBlocks.add(cell);
    }
  }

  @override
  Color backgroundColor() => Colors.grey;
}
