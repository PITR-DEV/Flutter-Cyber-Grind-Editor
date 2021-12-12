import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

class QuitConfirmation extends StatefulWidget {
  const QuitConfirmation(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  _QuitConfirmationState createState() => _QuitConfirmationState();
}

class _QuitConfirmationState extends State<QuitConfirmation> {
  @override
  void initState() {
    super.initState();
    FlutterWindowClose.setWindowShouldCloseHandler(
      () async {
        return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text('Are you sure you want to quit?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Yes')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('No'))
                      ]);
                }) ??
            false;
      },
    );
  }

  @override
  void dispose() {
    FlutterWindowClose.setWindowShouldCloseHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
