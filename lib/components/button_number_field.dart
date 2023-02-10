import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/components/input/fat_button.dart';
import 'package:cgef/components/input/fat_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class ButtonNumberField extends ConsumerStatefulWidget {
  ButtonNumberField({
    Key? key,
    this.initialValue = 0,
    this.onValueChanged,
    this.onSelect,
    this.min = -50,
    this.max = 50,
    this.active = false,
    this.child,
  }) : super(key: key);
  int initialValue = 0;
  Function(int)? onValueChanged = (int value) {};
  Function()? onSelect = () {};

  int min;
  int max;

  Widget? child;
  bool active;

  @override
  createState() => _ButtonNumberField();
}

class _ButtonNumberField extends ConsumerState<ButtonNumberField> {
  late TextEditingController controller;
  int storedValue = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.initialValue.toString(),
    );
    storedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FatButton(
          onPressed: () => widget.onSelect?.call(),
          active: widget.active,
          flowDown: widget.active,
          child: widget.child,
        ),
        if (widget.active)
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
                    onPressed: () {
                      setState(() {
                        storedValue--;
                        if (storedValue < widget.min) {
                          storedValue = widget.min;
                        }
                        controller.text = storedValue.toString();
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        widget.onValueChanged?.call(storedValue);
                      });
                    },
                    flowDown: false,
                    customBorderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                    child: const Text('-'),
                  ),
                ),
                Expanded(
                  child: FatInput(
                    controller: controller,
                    customBorderRadius: const BorderRadius.only(),
                    onChanged: (p0) {
                      widget.onValueChanged?.call(int.tryParse(p0) ?? 0);
                    },
                  ),
                ),
                Container(
                  width: 40,
                  height: 66,
                  margin: const EdgeInsets.only(left: 1),
                  child: FatButton(
                    onPressed: () {
                      setState(() {
                        storedValue++;
                        if (storedValue > widget.max) {
                          storedValue = widget.max;
                        }
                        controller.text = storedValue.toString();
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                        widget.onValueChanged?.call(storedValue);
                      });
                    },
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
    );
  }
}
