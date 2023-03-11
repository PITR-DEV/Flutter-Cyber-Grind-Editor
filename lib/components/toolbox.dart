import 'package:cgef/helpers/platform_helper.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/components/input/fat_button.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:layout/layout.dart';

class Toolbox extends ConsumerWidget {
  const Toolbox({Key? key}) : super(key: key);

  Widget rectWrap(Widget content) {
    if (PlatformHelper().isDesktop) {
      Expanded(
        child: content,
      );
    }
    return content;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Margin(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          const Text(
            'Toolbox',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            height: 12,
          ),
          Tooltip(
            message: 'Click',
            child: FatButton(
              onPressed: () {
                ref.read(toolProvider.notifier).state = Tool.point;
                toolChanged(ComponentRef(ref));
              },
              active: ref.watch(toolProvider) == Tool.point,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.create_outlined),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Click',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PlatformHelper().isDesktop
              ? Tooltip(
                  message: 'Brush',
                  child: FatButton(
                    onPressed: () {
                      ref.read(toolProvider.notifier).state = Tool.brush;
                      toolChanged(ComponentRef(ref));
                    },
                    active: ref.watch(toolProvider) == Tool.brush,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.brush_outlined),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Paint',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          if (true) //(!PlatformHelper().isDesktop)
            rectWrap(
              Tooltip(
                message: 'Fill Rect',
                child: FatButton(
                  onPressed: () {
                    ref.read(toolProvider.notifier).state = Tool.fillRect;
                    toolChanged(ComponentRef(ref));
                  },
                  active: ref.watch(toolProvider) == Tool.fillRect,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/box.svg',
                        color: ref.watch(toolProvider) == Tool.fillRect
                            ? Colors.black
                            : Colors.white,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Fill Rect',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(
            width: 12,
            height: 0,
          ),
          rectWrap(
            Tooltip(
              message: 'Outline Rect',
              child: FatButton(
                onPressed: () {
                  ref.read(toolProvider.notifier).state = Tool.outlineRect;
                  toolChanged(ComponentRef(ref));
                },
                active: ref.watch(toolProvider) == Tool.outlineRect,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_box_outline_blank),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Border',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // if (PlatformHelper().isDesktop)
          //   Row(
          //     children: rectButtons(ref),
          //   ),
        ],
      ),
    );
  }
}
