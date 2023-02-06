import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

class QuitConfirmation extends StatefulWidget {
  const QuitConfirmation(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  _QuitConfirmationState createState() => _QuitConfirmationState();
}

class _QuitConfirmationState extends State<QuitConfirmation> {
  Future<bool> _dialog() async {
    var btnTxtStyle = const TextStyle(color: Colors.white);

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to quit?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Yes',
                style: btnTxtStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'No',
                style: btnTxtStyle,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FlutterWindowClose.setWindowShouldCloseHandler(
      () async {
        return await _dialog();
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
