import 'package:cgef/helpers/grid_helper.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:cgef/widgets/input/grid_block_button.dart';
import 'package:cgef/widgets/pinch_zoom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class ArenaGrid extends ConsumerStatefulWidget {
  const ArenaGrid({Key? key}) : super(key: key);

  @override
  createState() => _ArenaGridState();
}

class _ArenaGridState extends ConsumerState<ArenaGrid> {
  List<Widget> _generateGridBlocks() {
    return List.generate(
      ParsingHelper.arenaSize * ParsingHelper.arenaSize,
      (i) {
        // top left corner 0,0
        // cell to the right 1,0
        final index = i;
        return GridBlockButton(index);
      },
    );
  }

  Widget? _buildArenaGrid(BuildContext context) {
    final grid = _generateGridBlocks();
    // var rows = <Widget>[];

    // for (var i = 0; i < ParsingHelper.arenaSize; i++) {
    //   rows.add(
    //     Column(
    //       children: grid.sublist(i * ParsingHelper.arenaSize, (i + 1) * ParsingHelper.arenaSize),
    //     ),
    //   );
    // }

    // return Row(
    //   children: rows,
    // );

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: ParsingHelper.arenaSize,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      children: grid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinchable = context.breakpoint <= LayoutBreakpoint.xs;

    final grid = Listener(
      onPointerDown: (event) => paintStart(ref),
      onPointerUp: (event) => paintStop(ref),
      child: _buildArenaGrid(context)!,
    );

    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: pinchable
                ? PinchZoom(
                    maxScale: 4,
                    child: grid,
                  )
                : grid,
          ),
        ),
        const SizedBox(
          height: 12,
        )
      ],
    );
  }
}
