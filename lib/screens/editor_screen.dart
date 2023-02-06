import 'dart:io';

import 'package:cgef/helpers/grid_helper.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/components/exception_dialog.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/components/arena_grid.dart';
import 'package:cgef/components/input/tab_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:path_provider/path_provider.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  String _getExportableString() {
    var grid = getGrid(ComponentRef(ref));
    var exportableString = ParsingHelper().stringifyPattern(grid);
    return exportableString;
  }

  Future<bool> export() async {
    try {
      var date = DateTime.now();
      String? outputPath;
      final fileName =
          '${date.hour}_${date.minute} - ${date.day}_${date.month}_${date.year}.cgp';

      if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
        var path = await getExternalStorageDirectory();
        outputPath = p.join(path!.path, fileName);

        final file = File(outputPath);
        await file.writeAsString(_getExportableString());

        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: const Text(
        //         'Exported',
        //       ),
        //       content: SelectableText(
        //         'File saved to:\n${path.path}\n\nas\n\n$fileName',
        //         maxLines: 8,
        //       ),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: const Text(
        //             'ok',
        //           ),
        //         )
        //       ],
        //     );
        //   },
        // );
        //print(path);
        return true;
      }

      var resEx =
          // p.join(
          //     p.join('C:', 'Program Files (x86)', 'Steam', 'steamapps', 'common',
          //         'ULTRAKILL', 'ULTRAKILL_Data', 'StreamingAssets'),
          //     'cgef',
          //     'cgef.exe');
          Platform.resolvedExecutable;

      var exFile = File(resEx);
      if (exFile.parent.parent.parent.parent.existsSync()) {
        var ultrakillDirectory = exFile.parent.parent.parent.parent;

        if (ultrakillDirectory.path.split(Platform.pathSeparator).last ==
            "ULTRAKILL") {
          print('ULTRAKILL dir spotted');

          var patternsDir = Directory(
              p.join(ultrakillDirectory.path, 'Cybergrind', 'Patterns'));
          if (patternsDir.existsSync()) {
            outputPath = patternsDir.path;
          }
        } else {
          print('cgef seems to be not in StreamingAssets.');
          print('attempting to use default path');
          outputPath = p.join('C:', 'Program Files (x86)', 'Steam', 'steamapps',
              'common', 'ULTRAKILL', 'Cybergrind', 'Patterns');
        }
      }

      print('Setting default filename to ' + (outputPath ?? 'null'));

      outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Export your pattern:',
        fileName: fileName,
        initialDirectory: outputPath,
        allowedExtensions: ['cgp'],
        type: FileType.custom,
      );

      print('User selected ' + (outputPath ?? 'null'));

      if (outputPath == null) return false;

      if (!outputPath.endsWith('.cgp')) {
        outputPath += '.cgp';
      }

      await File(outputPath).writeAsString(_getExportableString());
      return true;
    } catch (ex, stack) {
      spawnExceptionDialog(context, "$ex\n$stack");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gridCentered = context.breakpoint > LayoutBreakpoint.xs &&
        context.breakpoint > LayoutBreakpoint.sm;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 52),
        child: Center(
          child: Margin(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TabButton(
                  onPressed: () {
                    ref.read(tabProvider.notifier).state = AppTab.heights;
                    ref.read(selectedGridBlockProvider.notifier).state = null;
                  },
                  active: ref.watch(tabProvider) == AppTab.heights,
                  text: 'Heights',
                  collapsed: !gridCentered,
                  collapsedIcon: const Icon(Icons.height),
                ),
                TabButton(
                  onPressed: () {
                    ref.read(tabProvider.notifier).state = AppTab.prefabs;
                    ref.read(selectedGridBlockProvider.notifier).state = null;
                  },
                  active: ref.watch(tabProvider) == AppTab.prefabs,
                  text: 'Prefabs',
                  collapsed: !gridCentered,
                  collapsedIcon: const Icon(Icons.widgets),
                ),
                TabButton(
                  onPressed: export,
                  text: 'Export',
                  collapsed: !gridCentered,
                  collapsedIcon: const Icon(Icons.save),
                )
              ],
            ),
          ),
        ),
      ),
      body: gridCentered
          ? const Center(
              child: ArenaGrid(),
            )
          : ArenaGrid(),
    );
  }
}
