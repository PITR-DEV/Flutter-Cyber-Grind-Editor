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
    final buttonStyle = OutlinedButton.styleFrom(
      foregroundColor: active ? Colors.black : Colors.white,
      // padding:
      //     EdgeInsets.symmetric(horizontal: 8, vertical: noPadding ? 0 : 24),
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
      textStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'vcr'),
    ).copyWith(
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return BorderSide(
            color: Colors.white.withOpacity(0.6),
            width: 3,
          );
        }
        return const BorderSide(
          color: Colors.white,
          width: 3,
        );
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered)) {
          return active ? Colors.white.withOpacity(0.8) : Colors.transparent;
        }
        return active ? Colors.white : Colors.transparent;
      }),
    );

    return Margin(
      margin: flowDown
          ? const EdgeInsets.only()
          : const EdgeInsets.only(bottom: LayoutHelper.standardMargin),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: flowDown ? 0 : 42,
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: child!,
        ),
      ),
    );
  }
}
