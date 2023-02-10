import 'package:cgef/components/button_number_field.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/components/input/fat_button.dart';
import 'package:cgef/components/input/fat_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class ToolOptions extends ConsumerStatefulWidget {
  const ToolOptions({Key? key}) : super(key: key);

  @override
  createState() => _ToolOptions();
}

class _ToolOptions extends ConsumerState<ToolOptions> {
  @override
  Widget build(BuildContext context) {
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
          ButtonNumberField(
            initialValue: ref.read(setToValueProvider),
            onValueChanged: (newValue) {
              ref.read(setToValueProvider.notifier).state = newValue;
            },
            onSelect: () => ref.read(toolModifierProvider.notifier).state =
                ToolModifier.setTo,
            active: ref.watch(toolModifierProvider) == ToolModifier.setTo,
            child: const Text('Set To'),
          ),
          ButtonNumberField(
            initialValue: ref.read(plusValueProvider),
            onValueChanged: (newValue) {
              ref.read(plusValueProvider.notifier).state = newValue;
            },
            onSelect: () => ref.read(toolModifierProvider.notifier).state =
                ToolModifier.plusValue,
            active: ref.watch(toolModifierProvider) == ToolModifier.plusValue,
            child: const Text('Plus'),
          )
        ],
      ),
    );
  }
}
