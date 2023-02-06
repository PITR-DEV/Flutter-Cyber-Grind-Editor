import 'dart:async';
import 'dart:ui';

import 'package:cgef/flame/cell.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GridGame extends FlameGame
    with HasTappables, HasComponentRef, HasGameRef {
  GridGame(WidgetRef ref) {
    HasComponentRef.widgetRef = ref;
  }

  List<GridBlockComponent> gridBlocks = [];
  int? hoveredIndex;

  void updateCursorPosition(Offset offset) {
    // print('updateCursorPosition: $offset');
    final size = gameRef.size;
    // convert cursor x and y, into grid x and y and then into index
    final x = (offset.dx / size.x * ParsingHelper.arenaSize).floor();
    final y = (offset.dy / size.y * ParsingHelper.arenaSize).floor();
    final index = y * ParsingHelper.arenaSize + x;
    if (index == hoveredIndex) return;
    // setHover(ref, index);
    hoverOverBlock(ref, index);
    hoveredIndex = index;
  }

  @override
  onLoad() async {
    await super.onLoad();
    // create a components for all grid elements
    const total = ParsingHelper.arenaSize * ParsingHelper.arenaSize;
    for (var i = 0; i < total; i++) {
      final cell = GridBlockComponent(i);
      add(cell);
      gridBlocks.add(cell);
    }
  }
}
