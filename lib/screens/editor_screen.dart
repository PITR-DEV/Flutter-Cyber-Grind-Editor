import 'dart:io';

import 'package:cgef/helpers/platform_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  Future<void> _export() async {
    var date = DateTime.now();
    String? outputPath;
    final fileName = date.hour.toString() +
        '_' +
        date.minute.toString() +
        ' - ' +
        date.day.toString() +
        '_' +
        date.month.toString() +
        '_' +
        date.year.toString() +
        '.cgp';

    if (PlatformHelper().isDesktop) {
      // No need to verify, seems to be automatically handled.
      // Maybe in the future, pass the game path to cgef while launching.
      var patternsPath = p.join('C:', 'Program Files (x86)', 'Steam',
          'steamapps', 'common', 'ULTRAKILL', 'CyberGrind', 'Patterns');

      print(patternsPath);
      print(fileName);
      print(p.join(patternsPath, fileName));
      outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Export your pattern:',

        // Was p.join(patternsPath, fileName) before, but it somehow doesn't work anymore.
        fileName: fileName,
        allowedExtensions: ['cgp'],
        type: FileType.custom,
      );
      print(outputPath);
    } else {
      return;
      // Mobile
      final dir =
          Directory((await getExternalStorageDirectory())!.path + '/CGEF/');
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if (!(await dir.exists())) {
        dir.create();
      }

      outputPath = p.join(dir.path, fileName);
    }

    if (outputPath == null) return;

    var grid = ScopedModel.of<GridState>(context).grid;
    var exportableString = ParsingHelper().stringifyPattern(grid);

    await File(outputPath).writeAsString(exportableString);

    if (!PlatformHelper().isDesktop) {
      Fluttertoast.showToast(
          msg: 'Pattern exported to $outputPath',
          toastLength: Toast.LENGTH_LONG);
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
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ScopedModelDescendant<AppState>(
                  builder: (context, child, model) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TabButton(
                            onPressed: () => model.setTab(AppTab.heights),
                            active: model.tab == AppTab.heights,
                            text: 'Heights'),
                        TabButton(
                            onPressed: () => model.setTab(AppTab.prefabs),
                            active: model.tab == AppTab.prefabs,
                            text: 'Prefabs'),
                        TabButton(onPressed: _export, text: 'Export')
                      ],
                    );
                  },
                )),
            margin: const EdgeInsets.only(bottom: 12),
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
