import 'package:cgef/helpers/color_helper.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/models/grid_block.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:layout/layout.dart';

class GridBlockButton extends ConsumerWidget {
  const GridBlockButton(this.index, {Key? key}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final block = ref.watch(gridProvider(index));

    var activeHeavy = false;
    var isHovered = false;

    isHovered = ref.watch(hoveredProvider).contains(index);
    if (ref.watch(isPaintingProvider) && isHovered) {
      activeHeavy = true;
    }

    return InkWell(
      enableFeedback: false,
      onTap: () {
        onClickBlock(ref, block.index);
      },
      onHover: (value) => {if (value) hoverOverBlock(ref, block.index)},
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorHelper.heightToColor(
                block.height,
              ),
              border: Border.all(
                color: activeHeavy
                    ? Colors.red
                    : isHovered
                        ? Colors.white
                        : Colors.grey,
                width: activeHeavy
                    ? 3
                    : isHovered
                        ? 2
                        : 0,
              ),
            ),
            child: Center(
              child: Text(
                ref.watch(tabProvider) == AppTab.heights
                    ? block.height.toString()
                    : block.prefab,
                // (index ~/ 16).toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: ColorHelper.blockTextColor(
                    block.height,
                    hidden: ref.watch(tabProvider) == AppTab.prefabs &&
                        block.prefab == '0',
                  ),
                ),
              ),
            ),
          ),
          block.prefab == 's'
              ? Margin(
                  margin: const EdgeInsets.all(3),
                  child: SvgPicture.asset(
                    'assets/Stairs_Map_Preview.svg',
                    color: ColorHelper.blockOverlayColor(block.height),
                    height: 10,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
