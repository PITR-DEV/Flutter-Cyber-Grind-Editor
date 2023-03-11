import 'package:cgef/flame/cell.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
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

  void resetLocalHover() {
    hoveredIndex = null;
  }

  void updateCursorPosition(Offset offset) {
    final size = gameRef.size;
    // make sure offset isn't less than 0 or greater than the size of the grid
    if (offset.dx <= 0 ||
        offset.dy <= 0 ||
        offset.dx >= size.x ||
        offset.dy >= size.y) {
      hoveredIndex = null;
      ref.read(hoveredCellIndexProvider.notifier).state = null;
      cancelClick(ref);
      return;
    }

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
    var stairsImage = await Flame.images.load('stairs_tiny.png');
    const total = ParsingHelper.arenaSize * ParsingHelper.arenaSize;
    for (var i = 0; i < total; i++) {
      final cell = GridBlockComponent(i, stairsImage: Sprite(stairsImage));
      add(cell);
      gridBlocks.add(cell);
    }
  }

  @override
  Color backgroundColor() => Colors.grey;
}
