import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PrefabIndicator extends PositionComponent {
  PrefabIndicator(Vector2 size) : super(size: size);

  CircleComponent? circle;
  CircleComponent? outline;

  void hide() {
    if (circle != null) {
      circle!.opacity = 0;
    }
    if (outline != null) {
      outline!.opacity = 0;
    }
  }

  void show(Color color) {
    if (circle == null) {
      circle = CircleComponent(
        radius: size.x / 4.25,
        priority: 2,
        position: size / 2,
        anchor: Anchor.center,
      );
      add(circle!);
    }
    circle?.opacity = 1;
    circle?.setColor(color);

    if (outline == null) {
      outline = CircleComponent(
        radius: size.x / 3.5,
        priority: 1,
        position: size / 2,
        anchor: Anchor.center,
      );
      outline!.setColor(Colors.black);
      add(outline!);
    }
    outline?.opacity = 1;
  }
}
