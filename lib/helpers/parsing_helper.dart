import 'package:cgef/models/grid_block.dart';

class ParsingHelper {
  static const arenaSize = 16;

  List<List<GridBlock>> importString(String input) {
    final lines = input.split('\n');

    if (lines.length != arenaSize * 2 + 1) {
      throw Exception('Invalid arena size');
    }

    final grid = List.generate(
        ParsingHelper.arenaSize,
        (x) => List.generate(
              ParsingHelper.arenaSize,
              (y) => GridBlock(
                height: 0,
                prefab: '0',
                index: x * arenaSize + y,
              ),
            ),
        growable: false);

    for (var y = 0; y < ParsingHelper.arenaSize; y++) {
      var containerOpened = false;
      var containerBuilder = '';
      var adjustedX = 0;

      for (var x = 0; x < lines[y].length; x++) {
        if (lines[y][x] == '(') {
          containerOpened = true;
          continue;
        }

        if (lines[y][x] == ')') {
          if (containerOpened) {
            grid[adjustedX][y] = grid[adjustedX][y]
                .copyWith(height: int.parse(containerBuilder));
            containerBuilder = '';
            containerOpened = false;
            adjustedX++;
            continue;
          } else {
            throw Exception('Closed unopened container at $x, $y');
          }
        }

        if (containerOpened) {
          containerBuilder += lines[y][x];
          continue;
        } else if (int.tryParse(lines[y][x]) != null) {
          grid[adjustedX][y] =
              grid[adjustedX][y].copyWith(height: int.parse(lines[y][x]));
          adjustedX++;
          continue;
        }
      }
    }

    for (var y = 0; y < arenaSize; y++) {
      for (var x = 0; x < arenaSize; x++) {
        grid[x][y] = grid[x][y].copyWith(prefab: lines[y + arenaSize + 1][x]);
      }
    }

    return grid;
  }

  String stringifyPattern(List<List<GridBlock>> source) {
    var builder = '';

    for (var y = 0; y < arenaSize; y++) {
      for (var x = 0; x < arenaSize; x++) {
        if (source[x][y].height < 0 || source[x][y].height > 9) {
          builder += '(${source[x][y].height})';
        } else {
          builder += source[x][y].height.toString();
        }
      }
      builder += '\n';
    }
    builder += '\n';

    for (var y = 0; y < arenaSize; y++) {
      for (var x = 0; x < arenaSize; x++) {
        builder += source[x][y].prefab;
      }
      if (y != arenaSize - 1) builder += '\n';
    }

    return builder;
  }
}
