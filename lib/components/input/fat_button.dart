import 'package:cgef/helpers/layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class FatButton extends StatelessWidget {
  const FatButton({
    Key? key,
    this.onPressed,
    this.active = false,
    this.flowDown = false,
    this.noPadding = false,
    this.child,
    this.customBorderRadius,
  }) : super(key: key);
  final Function()? onPressed;
  final bool noPadding;
  final bool flowDown;
  final bool active;
  final Widget? child;
  final BorderRadiusGeometry? customBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: flowDown
          ? const EdgeInsets.only()
          : const EdgeInsets.only(bottom: LayoutHelper.standardMargin),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: active ? Colors.black : Colors.white,
            backgroundColor: active ? Colors.white : Colors.transparent,
            padding: EdgeInsets.symmetric(
                horizontal: 8, vertical: noPadding ? 0 : 24),
            shape: RoundedRectangleBorder(
              borderRadius: customBorderRadius != null
                  ? customBorderRadius!
                  : flowDown
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        )
                      : BorderRadius.circular(8),
            ),
            side: const BorderSide(
              color: Colors.white,
              width: 3,
            ),
            textStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'vcr'),
          ),
          child: child!,
        ),
      ),
    );
  }
}
