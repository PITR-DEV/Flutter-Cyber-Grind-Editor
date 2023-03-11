import 'dart:ui';

import 'package:cgef/flame/grid.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class ArenaGrid extends ConsumerStatefulWidget {
  const ArenaGrid({Key? key}) : super(key: key);

  @override
  createState() => _ArenaGridState();
}

class _ArenaGridState extends ConsumerState<ArenaGrid> {
  Widget? cellGrid(BuildContext context) {
    final game = GridGame(ref);
    final cmpRef = ComponentRef(ref);
    return MouseRegion(
      onExit: (event) {
        if (!ref.read(isPaintingProvider)) {
          resetHover(cmpRef);
          game.resetLocalHover();
        }
      },
      child: Listener(
        onPointerDown: (event) {
          if (event.kind == PointerDeviceKind.mouse &&
              event.buttons == kSecondaryMouseButton) {
            handleMouseDownAlt(cmpRef);
          } else {
            handleMouseDown(cmpRef);
          }
        },
        onPointerUp: (event) => handleMouseUp(cmpRef),
        onPointerMove: (event) {
          game.updateCursorPosition(event.localPosition);
        },
        onPointerHover: (event) =>
            game.updateCursorPosition(event.localPosition),
        child: GameWidget(
          key: const Key('grid'),
          game: game,
          autofocus: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinchable = context.breakpoint <= LayoutBreakpoint.xs;

    final grid = cellGrid(context)!;

    return grid;
  }
}
