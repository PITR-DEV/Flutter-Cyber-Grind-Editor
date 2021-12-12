import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/state/app_state.dart';
import 'package:cgef/state/grid_state.dart';
import 'package:cgef/widgets/input/grid_block_button.dart';
import 'package:cgef/widgets/pinch_zoom_widget.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class ArenaGrid extends StatefulWidget {
  const ArenaGrid(this.model, {Key? key}) : super(key: key);

  final GridState model;

  @override
  _ArenaGridState createState() => _ArenaGridState();
}

class _ArenaGridState extends State<ArenaGrid> {
  List<Widget> _generateGridBlocks() {
    final appState = AppState.of(context);

    return List.generate(
      ParsingHelper.arenaSize * ParsingHelper.arenaSize,
      (index) {
        final block = widget.model.grid[index % ParsingHelper.arenaSize]
            [index ~/ ParsingHelper.arenaSize];

        return GridBlockButton(block,
            appState: appState, gridState: widget.model);
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
      crossAxisCount: ParsingHelper.arenaSize,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      children: grid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinchable = context.breakpoint <= LayoutBreakpoint.xs;
    final appState = AppState.of(context);
    final gridState = GridState.of(context);

    final grid = Listener(
      onPointerDown: (event) => gridState.paintStart(appState),
      onPointerUp: (event) => gridState.paintStop(appState),
      child: _buildArenaGrid(context)!,
    );

    return AspectRatio(
      aspectRatio: 1,
      child: pinchable
          ? PinchZoom(
              child: grid,
              maxScale: 4,
            )
          : grid,
    );
  }
}
