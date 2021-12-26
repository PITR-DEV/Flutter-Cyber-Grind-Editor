import 'package:cgef/screens/main_layout.dart';
import 'package:cgef/screens/editor_screen.dart';
import 'package:cgef/screens/home_screen.dart';
import 'package:cgef/state/app_state.dart';
import 'package:cgef/state/grid_state.dart';
import 'package:cgef/widgets/quit_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:layout/layout.dart';
import 'package:scoped_model/scoped_model.dart';

Future<void> main() async {
  Widget rootWidget = const AppRoot();
  rootWidget = Layout(child: rootWidget);
  rootWidget = ScopedModel<AppState>(
    model: AppState(),
    child: rootWidget,
  );
  rootWidget = ScopedModel<GridState>(
    model: GridState(),
    child: rootWidget,
  );

  runApp(rootWidget);
}

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    FlutterWindowClose.setWindowShouldCloseHandler(null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Grind Editor',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/editor': (context) => const QuitConfirmation(
              MainLayout(
                content: EditorScreen(),
              ),
            ),
      },
    );
  }
}
