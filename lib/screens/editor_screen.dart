import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/state/app_state.dart';
import 'package:cgef/state/grid_state.dart';
import 'package:cgef/widgets/arena_grid.dart';
import 'package:cgef/widgets/input/tab_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:scoped_model/scoped_model.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  Future<void> _export() async {
    var date = DateTime.now();

    var patternsPath = p.join('C:', 'Program Files (x86)', 'Steam', 'steamapps',
        'common', 'ULTRAKILL', 'CyberGrind', 'Patterns');

    // No need to verify, seems to be automatically handled.
    // Maybe in the future, pass the game path to cgef while launching.

    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Export your pattern:',
      fileName: p.join(
          patternsPath,
          date.hour.toString() +
              '_' +
              date.minute.toString() +
              ' - ' +
              date.day.toString() +
              '_' +
              date.month.toString() +
              '_' +
              date.year.toString() +
              '.cgp'),
      allowedExtensions: ['cgp'],
      type: FileType.custom,
    );

    if (outputPath == null) return;

    var grid = ScopedModel.of<GridState>(context).grid;
    var exportableString = ParsingHelper().stringifyPattern(grid);

    await File(outputPath).writeAsString(exportableString);
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
