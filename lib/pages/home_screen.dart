import 'dart:io';

import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:cgef/components/input/fat_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String appVersion = '';
  bool showContinue = false;

  void _openFilePicker() async {
    var specifyExtension =
        Platform.isWindows || Platform.isLinux || Platform.isMacOS;

    String? path;

    if (!specifyExtension) {
      var strg = await getExternalStorageDirectory();
      path = strg!.path;
    }

    // print('initial directory: $path');

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: specifyExtension ? ['cgp'] : null,
      type: specifyExtension ? FileType.custom : FileType.any,
      // initialDirectory: path,
    );

    if (result == null) return;
    var file = File(result.files.single.path!);
    file.readAsString().then((String contents) {
      loadFromString(ref, contents);
      setState(() {
        showContinue = true;
      });
      Navigator.of(context).pushNamed('/editor');
    });
  }

  void _openSourceCode() async {
    const sourceUrl = 'https://pitr.dev/cgef_dl';
    await launchUrlString(sourceUrl, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var bigLogo = context.breakpoint > LayoutBreakpoint.xs;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Logo.png',
                  width: bigLogo ? 400 : 250,
                  height: 70,
                ),
                const Text(
                  'PATTERN EDITOR',
                  style: TextStyle(fontSize: 22, fontFamily: 'vcr'),
                ),
                const SizedBox(height: 14),
                showContinue
                    ? Column(
                        children: [
                          SizedBox(
                            width: 200,
                            child: FatButton(
                              child: const Text('CONTINUE'),
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/editor'),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      )
                    : const Column(),
                SizedBox(
                  width: 200,
                  child: FatButton(
                    onPressed: () {
                      newPattern(ref);
                      setState(() {
                        showContinue = true;
                      });
                      Navigator.pushNamed(context, '/editor');
                    },
                    child: const Text('NEW'),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: FatButton(
                    onPressed: _openFilePicker,
                    child: const Text('LOAD'),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'CGEF $appVersion',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withAlpha(120),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    onPressed: _openSourceCode,
                    child: const Text('Source Code'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: IconButton(
                tooltip: 'Settings',
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
