import 'dart:io';

import 'package:cgef/widgets/exception_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/state/app_state.dart';
import 'package:cgef/state/grid_state.dart';
import 'package:cgef/widgets/arena_grid.dart';
import 'package:cgef/widgets/input/tab_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String _getExportableString() {
    var grid = ScopedModel.of<GridState>(context).grid;
    var exportableString = ParsingHelper().stringifyPattern(grid);
    return exportableString;
  }

  Future<void> _export() async {
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

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Exported',
              ),
              content: SelectableText(
                'File saved to:\n${path.path}\n\nas\n\n$fileName',
                maxLines: 8,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ok',
                  ),
                )
              ],
            );
          },
        );
        //print(path);
        return;
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

      if (outputPath == null) return;

      if (!outputPath.endsWith('.cgp')) {
        outputPath += '.cgp';
      }

      await File(outputPath).writeAsString(_getExportableString());
    } catch (ex, stack) {
      spawnExceptionDialog(context, "$ex\n$stack");
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
            child: ScopedModelDescendant<AppState>(
              builder: (context, child, model) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabButton(
                      onPressed: () => model.setTab(AppTab.heights),
                      active: model.tab == AppTab.heights,
                      text: 'Heights',
                      collapsed: !gridCentered,
                      collapsedIcon: const Icon(Icons.height),
                    ),
                    TabButton(
                      onPressed: () => model.setTab(AppTab.prefabs),
                      active: model.tab == AppTab.prefabs,
                      text: 'Prefabs',
                      collapsed: !gridCentered,
                      collapsedIcon: const Icon(Icons.widgets),
                    ),
                    TabButton(
                      onPressed: _export,
                      text: 'Export',
                      collapsed: !gridCentered,
                      collapsedIcon: const Icon(Icons.save),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: ScopedModelDescendant<GridState>(
        builder: (context, child, model) {
          return gridCentered
              ? Center(
                  child: ArenaGrid(model),
                )
              : ArenaGrid(model);
        },
      ),
    );
  }
}
