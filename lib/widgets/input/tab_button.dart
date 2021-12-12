import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    Key? key,
    this.onPressed,
    this.text = '',
    this.active = false,
  }) : super(key: key);

  final Function()? onPressed;
  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Margin(
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 17, fontFamily: 'vcr'),
        ),
        style: OutlinedButton.styleFrom(
          primary: active ? Colors.black : Colors.white,
          backgroundColor: active ? Colors.white : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          side: const BorderSide(
            color: Colors.white,
            width: 3,
          ),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
