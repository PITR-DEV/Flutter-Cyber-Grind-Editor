import 'package:cgef/models/enums.dart';

String getPrefabSymbol(Prefab prefab) {
  switch (prefab) {
    case Prefab.none:
      return '0';
    case Prefab.melee:
      return 'n';
    case Prefab.projectile:
      return 'p';
    case Prefab.jumpPad:
      return 'J';
    case Prefab.stairs:
      return 's';
    case Prefab.hideous:
      return 'H';
  }
}

Prefab getPrefabFromSymbol(String symbol) {
  switch (symbol) {
    case '0':
      return Prefab.none;
    case 'n':
      return Prefab.melee;
    case 'p':
      return Prefab.projectile;
    case 'J':
      return Prefab.jumpPad;
    case 's':
      return Prefab.stairs;
    case 'H':
      return Prefab.hideous;
  }

  return Prefab.none;
}
