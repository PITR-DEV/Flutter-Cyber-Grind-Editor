import 'package:cgef/helpers/layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layout/layout.dart';

class FatInput extends StatelessWidget {
  const FatInput({Key? key, this.controller, this.onChanged}) : super(key: key);
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Margin(
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              try {
                final text = newValue.text;
                if (text.isNotEmpty && text != '-') {
                  var num = double.parse(text);
                  if (num > 50) return newValue.copyWith(text: '50');
                  if (num < -50) return newValue.copyWith(text: '-50');
                }
                return newValue;
              } catch (e) {}
              return oldValue;
            }),
          ],
          onEditingComplete: () {
            var parsedNum = int.tryParse(controller!.text);
            if (parsedNum == null) {
              controller!.text = '0';
            }
          },
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 3,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 3,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ),
      ),
      margin: const EdgeInsets.only(bottom: LayoutHelper.standardMargin),
    );
  }
}
