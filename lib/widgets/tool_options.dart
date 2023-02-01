import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/widgets/input/fat_button.dart';
import 'package:cgef/widgets/input/fat_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class ToolOptions extends ConsumerStatefulWidget {
  const ToolOptions({Key? key}) : super(key: key);

  @override
  createState() => _ToolOptions();
}

class _ToolOptions extends ConsumerState<ToolOptions> {
  TextEditingController? setToFieldController;
  TextEditingController? plusFieldController;

  @override
  void dispose() {
    setToFieldController?.dispose();
    plusFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (setToFieldController == null) {
      setToFieldController = TextEditingController(
        text: ref.watch(setToValueProvider).toString(),
      );
      plusFieldController = TextEditingController(
        text: ref.watch(plusValueProvider).toString(),
      );
    }

    return Margin(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          const Text(
            'Options',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            height: 12,
          ),
          FatButton(
            onPressed: () => ref.read(toolModifierProvider.notifier).state =
                ToolModifier.plusOne,
            active: ref.watch(toolModifierProvider) == ToolModifier.plusOne,
            child: const Text('Plus One'),
          ),
          FatButton(
            onPressed: () => ref.read(toolModifierProvider.notifier).state =
                ToolModifier.minusOne,
            active: ref.watch(toolModifierProvider) == ToolModifier.minusOne,
            child: const Text('Minus One'),
          ),
          FatButton(
            onPressed: () => ref.read(toolModifierProvider.notifier).state =
                ToolModifier.setTo,
            active: ref.watch(toolModifierProvider) == ToolModifier.setTo,
            flowDown: ref.watch(toolModifierProvider) == ToolModifier.setTo,
            child: const Text('Set To'),
          ),
          if (ref.watch(toolModifierProvider) == ToolModifier.setTo)
            FatInput(
              controller: setToFieldController,
              onChanged: (p0) =>
                  // model.setToolOptions(setToValue: int.tryParse(p0)),
                  ref.read(setToValueProvider.notifier).state =
                      int.tryParse(p0) ?? 0,
            ),
          FatButton(
              onPressed: () => ref.read(toolModifierProvider.notifier).state =
                  ToolModifier.plusValue,
              active: ref.watch(toolModifierProvider) == ToolModifier.plusValue,
              flowDown:
                  ref.watch(toolModifierProvider) == ToolModifier.plusValue,
              child: const Text('Plus')),
          if (ref.watch(toolModifierProvider) == ToolModifier.plusValue)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 66,
                    margin: const EdgeInsets.only(right: 1),
                    child: FatButton(
                      onPressed: () => ref
                          .read(toolModifierProvider.notifier)
                          .state = ToolModifier.plusValue,
                      flowDown: false,
                      customBorderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                      child: const Text('-'),
                    ),
                  ),
                  Expanded(
                    child: FatInput(
                      controller: plusFieldController,
                      customBorderRadius: const BorderRadius.only(),
                      onChanged: (p0) => ref
                          .read(plusValueProvider.notifier)
                          .state = int.tryParse(p0) ?? 0,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 66,
                    margin: const EdgeInsets.only(left: 1),
                    child: FatButton(
                      onPressed: () => ref
                          .read(toolModifierProvider.notifier)
                          .state = ToolModifier.plusValue,
                      flowDown: false,
                      customBorderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8),
                      ),
                      child: const Text('+'),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
