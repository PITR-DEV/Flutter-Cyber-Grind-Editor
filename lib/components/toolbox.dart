import 'package:cgef/helpers/platform_helper.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/components/input/fat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class Toolbox extends ConsumerWidget {
  const Toolbox({Key? key}) : super(key: key);

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
            message: 'Point',
            child: FatButton(
              onPressed: () =>
                  ref.read(toolProvider.notifier).state = Tool.point,
              active: ref.watch(toolProvider) == Tool.point,
              child: const Icon(Icons.create_outlined),
            ),
          ),
          PlatformHelper().isDesktop
              ? Tooltip(
                  message: 'Brush',
                  child: FatButton(
                    onPressed: () =>
                        ref.read(toolProvider.notifier).state = Tool.brush,
                    active: ref.watch(toolProvider) == Tool.brush,
                    child: const Icon(Icons.brush_outlined),
                  ),
                )
              : Container(),
          Tooltip(
            message: 'Fill Rect',
            child: FatButton(
              onPressed: () =>
                  ref.read(toolProvider.notifier).state = Tool.fillRect,
              active: ref.watch(toolProvider) == Tool.fillRect,
              child: const Icon(Icons.aspect_ratio_outlined),
            ),
          ),
          Tooltip(
            message: 'Outline Rect',
            child: FatButton(
              onPressed: () =>
                  ref.read(toolProvider.notifier).state = Tool.outlineRect,
              active: ref.watch(toolProvider) == Tool.outlineRect,
              child: const Icon(Icons.check_box_outline_blank),
            ),
          ),
        ],
      ),
    );
  }
}
