import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/state/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class GridState extends Model {
  BuildContext? buildContext;

  List<List<GridBlock>> _grid = List.generate(
      ParsingHelper.arenaSize,
      (i) => List.generate(
          ParsingHelper.arenaSize, (index) => GridBlock(0, '0', i, index)),
      growable: false);
  final List<int> _hoveredOverIndexes = [];
  final List<int> _paintedOverIndexes = [];
  bool _isPainting = false;

  GridState({this.buildContext});

  List<List<GridBlock>> get grid => _grid;

  void resetPattern() {
    _grid = List.generate(
        ParsingHelper.arenaSize,
        (i) => List.generate(
            ParsingHelper.arenaSize, (index) => GridBlock(0, '0', i, index)),
        growable: false);
    _hoveredOverIndexes.clear();
    _paintedOverIndexes.clear();
    _isPainting = false;
  }

  void loadFromString(String source) {
    var grid = ParsingHelper().importString(source);
    _grid = grid;
  }

  List<GridBlock> computeFill(int x1, int y1, int x2, int y2) {
    if (x1 > x2) {
      final temp = x1;
      x1 = x2;
      x2 = temp;
    }
    if (y1 > y2) {
      final temp = y1;
      y1 = y2;
      y2 = temp;
    }

    final List<GridBlock> relevantBlocks = [];
    for (int x = x1; x <= x2; x++) {
      for (int y = y1; y <= y2; y++) {
        relevantBlocks.add(_grid[x][y]);
      }
    }
    return relevantBlocks;
  }

  List<GridBlock> computeRectOutline(int x1, int y1, int x2, int y2) {
    if (x1 > x2) {
      final temp = x1;
      x1 = x2;
      x2 = temp;
    }
    if (y1 > y2) {
      final temp = y1;
      y1 = y2;
      y2 = temp;
    }

    final List<GridBlock> relevantBlocks = [];
    for (int x = x1; x <= x2; x++) {
      if (!relevantBlocks.contains(_grid[x][y1])) {
        relevantBlocks.add(_grid[x][y1]);
      }
    }
    for (int x = x1; x <= x2; x++) {
      if (!relevantBlocks.contains(_grid[x][y2])) {
        relevantBlocks.add(_grid[x][y2]);
      }
    }

    for (int y = y1 + 1; y < y2; y++) {
      if (!relevantBlocks.contains(_grid[x1][y])) {
        relevantBlocks.add(_grid[x1][y]);
      }
    }
    for (int y = y1 + 1; y < y2; y++) {
      if (!relevantBlocks.contains(_grid[x2][y])) {
        relevantBlocks.add(_grid[x2][y]);
      }
    }
    return relevantBlocks;
  }

  void onClickBlock(AppState appState, int x, int y) {
    final toolSelected = appState.toolSelectedGridBlockIndex;

    switch (appState.tool) {
      case Tool.point:
      case Tool.brush:
        affectBlock(appState, x, y);
        break;
      case Tool.fillRect:
        if (toolSelected == -1) {
          appState.setGridBlockSelected(x + y * ParsingHelper.arenaSize);
          hoverOver(appState, x, y);
        } else {
          computeFill(x, y, toolSelected % ParsingHelper.arenaSize,
                  toolSelected ~/ ParsingHelper.arenaSize)
              .forEach((element) {
            affectBlock(appState, element.x, element.y);
          });
          appState.setGridBlockSelected(-1);
          resetHover();
        }
        break;
      case Tool.outlineRect:
        if (toolSelected == -1) {
          appState.setGridBlockSelected(x + y * ParsingHelper.arenaSize);
          hoverOver(appState, x, y);
        } else {
          computeRectOutline(x, y, toolSelected % ParsingHelper.arenaSize,
                  toolSelected ~/ ParsingHelper.arenaSize)
              .forEach((element) {
            affectBlock(appState, element.x, element.y);
          });
          appState.setGridBlockSelected(-1);
          resetHover();
        }
        break;
    }

    notifyListeners();
  }

  void paintStart(AppState appState) {
    if (appState.tool != Tool.brush) return;
    _paintedOverIndexes.clear();
    _isPainting = true;

    var indexes = List.from(_hoveredOverIndexes);

    for (var element in indexes) {
      setHover(
          element % ParsingHelper.arenaSize, element ~/ ParsingHelper.arenaSize,
          heavy: true);
    }

    computePaint(appState);
  }

  void paintStop(AppState appsState) {
    _isPainting = false;
    resetHover();
    notifyListeners();
  }

  void computePaint(AppState appState) {
    if (!_isPainting) return;
    for (var element in _hoveredOverIndexes) {
      if (_paintedOverIndexes.contains(element)) continue;
      affectBlock(appState, element % ParsingHelper.arenaSize,
          element ~/ ParsingHelper.arenaSize);
      _paintedOverIndexes.add(element);
    }
  }

  int gridHeightLimiter(int value) {
    if (value > 50) return 50;
    if (value < -50) return -50;
    return value;
  }

  void affectBlock(AppState appState, int x, int y) {
    final activeTab = appState.tab;

    if (activeTab == AppTab.prefabs) {
      switch (appState.selectedPrefab) {
        case Prefab.none:
          _grid[x][y].prefab = '0';
          break;
        case Prefab.melee:
          _grid[x][y].prefab = 'n';
          break;
        case Prefab.projectile:
          _grid[x][y].prefab = 'p';
          break;
        case Prefab.jumpPad:
          _grid[x][y].prefab = 'J';
          break;
        case Prefab.stairs:
          _grid[x][y].prefab = 's';
          break;
        case Prefab.hideous:
          _grid[x][y].prefab = 'H';
          break;
      }
      return;
    }

    switch (appState.toolModifier) {
      case ToolModifier.plusOne:
        _grid[x][y].height += 1;
        break;
      case ToolModifier.minusOne:
        _grid[x][y].height -= 1;
        break;
      case ToolModifier.setTo:
        _grid[x][y].height = appState.setToValue;
        break;
      case ToolModifier.plusValue:
        _grid[x][y].height += appState.plusValue;
        break;
    }
    _grid[x][y].height = gridHeightLimiter(_grid[x][y].height);
  }

  void resetHover() {
    for (var element in _hoveredOverIndexes) {
      _grid[element % ParsingHelper.arenaSize]
              [element ~/ ParsingHelper.arenaSize]
          .isHovered = false;
      _grid[element % ParsingHelper.arenaSize]
              [element ~/ ParsingHelper.arenaSize]
          .activeHeavy = false;
    }
    _hoveredOverIndexes.clear();
  }

  void setHover(int x, int y, {bool heavy = false}) {
    if (x < 0 ||
        x > ParsingHelper.arenaSize - 1 ||
        y < 0 ||
        y > ParsingHelper.arenaSize - 1) {
      return;
    }
    if (heavy) {
      _grid[x][y].activeHeavy = true;
    } else {
      _grid[x][y].isHovered = true;
    }

    _hoveredOverIndexes.add(x + y * ParsingHelper.arenaSize);
  }

  void hoverOver(AppState appState, int x, int y) {
    final toolSelected = appState.toolSelectedGridBlockIndex;
    if (appState.tool != Tool.brush || !_isPainting) resetHover();
    setHover(x, y, heavy: appState.tool == Tool.brush && _isPainting);
    // hover neighbors
    switch (appState.tool) {
      case Tool.brush:
        computePaint(appState);
        break;
      // TODO different brush sizes
      /*setHover(x - 1, y);
        setHover(x + 1, y);
        setHover(x, y - 1);
        setHover(x, y + 1);
        break;*/
      case Tool.outlineRect:
      case Tool.fillRect:
        if (toolSelected == -1) {
          break;
        }

        var relevantBlocks = [];
        if (appState.tool == Tool.fillRect) {
          relevantBlocks = computeFill(
              x,
              y,
              toolSelected % ParsingHelper.arenaSize,
              toolSelected ~/ ParsingHelper.arenaSize);
        }
        if (appState.tool == Tool.outlineRect) {
          relevantBlocks = computeRectOutline(
              x,
              y,
              toolSelected % ParsingHelper.arenaSize,
              toolSelected ~/ ParsingHelper.arenaSize);
        }

        for (var element in relevantBlocks) {
          setHover(element.x, element.y, heavy: true);
        }
        break;
      case Tool.point:
        break;
    }
    notifyListeners();
  }

  static GridState of(BuildContext context) {
    return ScopedModel.of<GridState>(context, rebuildOnChange: true);
  }
}

class GridBlock {
  final int x;
  final int y;

  int height;
  String prefab;
  bool isHovered;
  bool activeHeavy;

  GridBlock(this.height, this.prefab, this.x, this.y,
      {this.isHovered = false, this.activeHeavy = false});
}
