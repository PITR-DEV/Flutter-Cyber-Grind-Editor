import 'package:flutter/material.dart';

void spawnExceptionDialog(BuildContext context, String error) {
  var btnTxtStyle = const TextStyle(color: Colors.white);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Things broke!',
        ),
        content: SelectableText(
          error,
          maxLines: 6,
        ),
        backgroundColor: Color.fromARGB(255, 61, 37, 35),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'oh, ok',
              style: btnTxtStyle,
            ),
          )
        ],
      );
    },
  );
}
