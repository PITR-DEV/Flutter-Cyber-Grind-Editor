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
          width: 480,
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
              title: const Text('Brush Tint'),
              subtitle: const Text(
                  'Indicate painted-over cells with a background tint'),
              trailing: Switch(
                value: ref.watch(Preferences.brushTintEnabled),
                onChanged: (value) {
                  ref.read(Preferences.brushTintEnabled.notifier).state = value;
                },
              ),
              leading: const Icon(Icons.brush),
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
