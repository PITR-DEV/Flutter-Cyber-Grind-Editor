import 'dart:io';

import 'package:cgef/helpers/grid_helper.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

String getNewFileName() {
  var date = DateTime.now();
  return '${date.hour}_${date.minute} - ${date.day}_${date.month}_${date.year}.cgp';
}

String getPath() {
  return p.join('C:', 'Program Files (x86)', 'Steam', 'steamapps', 'common',
      'ULTRAKILL', 'CyberGrind', 'Patterns');
}

Future<void> promptLoad(WidgetRef ref) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    initialDirectory: getPath(),
    allowedExtensions: ['cgp'],
    type: FileType.custom,
    lockParentWindow: true,
  );

  if (result != null) {
    var file = File(result.files.single.path!);
    loadFromString(ref, await file.readAsString());
    ref.read(filePath.notifier).state = file.path;
    showNotification('Pattern Loaded', ref);
  } else {
    // User canceled the picker
  }
}

Future<void> promptSaveAs(WidgetRef ref) async {
  var result = await FilePicker.platform.saveFile(
    initialDirectory: getPath(),
    allowedExtensions: ['cgp'],
    type: FileType.custom,
    lockParentWindow: true,
    fileName: getNewFileName(),
  );

  if (result != null) {
    var file = File(result);
    var grid = getGrid(ComponentRef(ref));
    var exportableString = ParsingHelper().stringifyPattern(grid);
    await file.writeAsString(exportableString);
    ref.read(filePath.notifier).state = file.path;
    showNotification('Pattern Saved!', ref);
  } else {
    // User canceled the picker
  }
}

Future<void> save(WidgetRef ref) async {
  var path = ref.read(filePath);
  if (path == null) {
    await promptSaveAs(ref);
  } else {
    var file = File(path);
    var grid = getGrid(ComponentRef(ref));
    var exportableString = ParsingHelper().stringifyPattern(grid);
    await file.writeAsString(exportableString);
    showNotification('Pattern Saved!', ref);
  }
}
