import 'dart:ui';

import 'package:bezier/bezier.dart';
import 'package:cgef/models/enums.dart';
import 'package:vector_math/vector_math.dart';

class ColorHelper {
  static final brightnessCurve = CubicBezier([
    Vector2(0, 0),
    Vector2(0, 255),
    Vector2(
      0.6,
      0,
    ),
    Vector2(1, 255)
  ]);

  static double evaluateHeight(height) {
    final emulatedX = (height + 10) / 30;
    final lineStart = Vector2(emulatedX, 0);
    final lineEnd = Vector2(emulatedX, 255);

    final intersections =
        brightnessCurve.intersectionsWithLineSegment(lineStart, lineEnd);
    if (intersections.isNotEmpty) {
      return intersections[0];
    } else {
      return height > 0 ? 1 : 0;
    }
  }

  static Color heightToColor(int height) {
    final brightness = evaluateHeight(height);
    final colorBrightness = (brightness * 255).toInt();
    return Color.fromARGB(
        255, colorBrightness, colorBrightness, colorBrightness);
  }

  static Color blockOverlayColor(int height) {
    if (height >= 20) height = 20;
    if (height <= -10) height = -10;

    if (height > 5) {
      height -= 6;
    } else {
      height += 3;
    }

    final brightness = evaluateHeight(height);
    final colorBrightness = (brightness * 255).toInt();
    return Color.fromARGB(
        255, colorBrightness, colorBrightness, colorBrightness);
  }

  static Color blockTextColor(int height, {bool hidden = false}) {
    final evaluatedHeight = evaluateHeight(height);
    if (evaluatedHeight > 0.3 && evaluatedHeight < 0.7) {
      return hidden
          ? const Color.fromARGB(20, 255, 255, 255)
          : const Color.fromARGB(255, 255, 255, 255);
    } else {
      final int color = ((1 - evaluatedHeight) * 255).toInt();
      return hidden
          ? Color.fromARGB(60, color, color, color)
          : Color.fromARGB(255, color, color, color);
    }
  }

  static Map<Prefab, Color> prefabColors = {
    Prefab.melee: const Color.fromARGB(255, 135, 185, 88),
    Prefab.projectile: const Color.fromARGB(255, 238, 184, 103),
    Prefab.jumpPad: const Color.fromARGB(255, 114, 175, 255),
    Prefab.hideous: const Color.fromARGB(255, 221, 85, 85),
  };
}
