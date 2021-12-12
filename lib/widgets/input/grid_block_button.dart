import 'package:cgef/helpers/color_helper.dart';
import 'package:cgef/state/app_state.dart';
import 'package:cgef/state/grid_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:layout/layout.dart';

class GridBlockButton extends StatelessWidget {
  const GridBlockButton(this.block,
      {Key? key, required this.appState, required this.gridState})
      : super(key: key);
  final GridBlock block;
  final AppState appState;
  final GridState gridState;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      onTap: () {
        gridState.onClickBlock(appState, block.x, block.y);
      },
      onHover: (value) =>
          {if (value) gridState.hoverOver(appState, block.x, block.y)},
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorHelper.heightToColor(
                block.height,
              ),
              border: Border.all(
                color: block.activeHeavy
                    ? Colors.red
                    : block.isHovered
                        ? Colors.white
                        : Colors.grey,
                width: block.activeHeavy
                    ? 3
                    : block.isHovered
                        ? 2
                        : 0,
              ),
            ),
            child: Center(
              child: Text(
                appState.tab == AppTab.heights
                    ? block.height.toString()
                    : block.prefab,
                // (index ~/ 16).toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: ColorHelper.blockTextColor(
                    block.height,
                    hidden:
                        appState.tab == AppTab.prefabs && block.prefab == '0',
                  ),
                ),
              ),
            ),
          ),
          block.prefab == 's'
              ? Margin(
                  child: SvgPicture.asset(
                    'assets/Stairs_Map_Preview.svg',
                    color: ColorHelper.blockOverlayColor(block.height),
                    height: 10,
                  ),
                  margin: const EdgeInsets.all(3),
                )
              : Container(),
        ],
      ),
    );
  }
}
