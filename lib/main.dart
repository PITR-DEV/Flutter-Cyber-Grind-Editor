import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:cgef/providers/pref_provider.dart';
import 'package:cgef/screens/main_layout.dart';
import 'package:cgef/screens/editor_screen.dart';
import 'package:cgef/screens/home_screen.dart';
import 'package:cgef/screens/settings.dart';
import 'package:cgef/widgets/quit_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:layout/layout.dart';

Future<void> main() async {
  Widget rootWidget = const AppRoot();
  rootWidget = Layout(child: rootWidget);
  rootWidget = ProviderScope(child: rootWidget);

  runApp(rootWidget);
}

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  @override
  void initState() {
    super.initState();
    FlutterWindowClose.setWindowShouldCloseHandler(null);
  }

  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.red,
      useMaterial3: true,
    );
    if (ref.watch(Preferences.blackBackgroundProvider)) {
      theme = theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          background: Colors.black,
          surface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
      );
    }
    return MaterialApp(
      title: 'Cyber Grind Editor',
      theme: theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/editor': (context) => const QuitConfirmation(
              MainLayout(
                content: EditorScreen(),
              ),
            ),
        '/settings': (context) => const SettingsPage(),
      },
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            if (ref.watch(Preferences.debugOverlay))
              Positioned(
                top: 8,
                left: 8,
                child: IgnorePointer(
                  child: Text(
                    'tab: ${ref.watch(tabProvider)}\n'
                    'tool: ${ref.watch(toolProvider)}\n'
                    'toolModifier: ${ref.watch(toolModifierProvider)}\n'
                    'selectedPrefabProvider: ${ref.watch(selectedPrefabProvider)}\n'
                    'pastHome: ${ref.watch(pastHomeProvider)}\n'
                    'hovered: [${ref.watch(hoveredProvider).join(', ')}]\n'
                    'isPainting: ${ref.watch(isPaintingProvider)}\n'
                    'painted: [${ref.watch(paintedOverProvider).join(', ')}]',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      backgroundColor: Colors.black.withAlpha(170),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
