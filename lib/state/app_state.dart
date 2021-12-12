import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class AppState extends Model {
  BuildContext? buildContext;

  Tool _tool = Tool.point;
  ToolModifier _toolModifier = ToolModifier.plusOne;
  Prefab _selectedPrefab = Prefab.none;
  AppTab _tab = AppTab.heights;

  int _setToValue = 0;
  int _plusValue = 2;

  int _toolSelectedGridBlock = -1;

  bool _pastHome = false;

  AppState({this.buildContext});

  Tool get tool => _tool;
  ToolModifier get toolModifier => _toolModifier;
  Prefab get selectedPrefab => _selectedPrefab;
  AppTab get tab => _tab;

  int get setToValue => _setToValue;
  int get plusValue => _plusValue;

  int get toolSelectedGridBlockIndex => _toolSelectedGridBlock;

  bool get pastHome => _pastHome;

  void setPastHome() {
    _pastHome = true;
  }

  void setToolOptions({int? setToValue, int? plusValue}) {
    _setToValue = setToValue ?? _setToValue;
    _plusValue = plusValue ?? _plusValue;
    notifyListeners();
  }

  void setTool(Tool tool) {
    _tool = tool;
    _toolSelectedGridBlock = -1;
    notifyListeners();
  }

  void setToolModifier(ToolModifier mod) {
    _toolModifier = mod;
    notifyListeners();
  }

  void setPrefab(Prefab prefab) {
    _selectedPrefab = prefab;
    notifyListeners();
  }

  void setTab(AppTab tab) {
    _tab = tab;
    _toolSelectedGridBlock = -1;
    notifyListeners();
  }

  void setGridBlockSelected(int index) {
    _toolSelectedGridBlock = index;
    notifyListeners();
  }

  static AppState of(BuildContext context) {
    return ScopedModel.of<AppState>(context, rebuildOnChange: true);
  }
}

enum AppTab { heights, prefabs }
enum Tool { point, brush, fillRect, outlineRect }
enum ToolModifier { plusOne, minusOne, setTo, plusValue }
enum Prefab { none, melee, projectile, jumpPad, stairs, hideous }
