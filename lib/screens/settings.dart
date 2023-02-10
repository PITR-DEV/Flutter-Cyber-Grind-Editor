import 'package:cgef/providers/pref_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: SizedBox(
          width: 460,
          child: ListView(children: [
            ListTile(
              title: const Text('Black Background'),
              subtitle: const Text('Remove the tint from the background'),
              trailing: Switch(
                value: ref.watch(Preferences.blackBackgroundProvider),
                onChanged: (value) {
                  ref.read(Preferences.blackBackgroundProvider.notifier).state =
                      value;
                },
              ),
              leading: const Icon(Icons.color_lens),
            ),
            ListTile(
              title: const Text('Show Editor App Bar'),
              subtitle: const Text('Show the navigation app bar in the editor'),
              trailing: Switch(
                value: ref.watch(Preferences.showEditorAppBar),
                onChanged: (value) {
                  ref.read(Preferences.showEditorAppBar.notifier).state = value;
                },
              ),
              leading: const Icon(Icons.arrow_back),
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            ListTile(
              title: const Text('Debug Overlay'),
              subtitle: const Text('Display the debug overlay'),
              trailing: Switch(
                value: ref.watch(Preferences.debugOverlay),
                onChanged: (value) {
                  ref.read(Preferences.debugOverlay.notifier).state = value;
                },
              ),
              leading: const Icon(Icons.bug_report),
            ),
          ]),
        ),
      ),
    );
  }
}
