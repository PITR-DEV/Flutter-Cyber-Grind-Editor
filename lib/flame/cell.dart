import 'dart:async';

import 'package:cgef/flame/prefab_indicator.dart';
import 'package:cgef/helpers/color_helper.dart';
import 'package:cgef/helpers/parsing_helper.dart';
import 'package:cgef/helpers/prefab_helper.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/models/grid_block.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:cgef/providers/pref_provider.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';

class GridBlockComponent extends RectangleComponent
    with Tappable, HasGameRef, HasComponentRef {
  GridBlockComponent(this.index, {required this.stairsImage});
  int index = 0;

  TextComponent? label;
  RectangleComponent? hover;
  SpriteComponent? stairsIcon;
  ColorEffect? overlayColorEffect;

  late PrefabIndicator prefabIndicator;

  Cell? lastBlockData;
  int? lastHeight;
  Sprite stairsImage;

  TextStyle textStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w500,
  );

  Cell get thisBlock => ref.read(gridProvider(index));
  CellState get thisState => ref.read(cellStates(index));
  AppTab get currentTab => ref.read(tabProvider);

  @override
  Future<void> onLoad() {
    prefabIndicator = PrefabIndicator(Vector2.all(
      cellSize(),
    ));
    add(prefabIndicator);
    return super.onLoad();
  }

  @override
  FutureOr<void> onMount() {
    super.onMount();

    priority = 1;

    const cellMulti = 0.98;
    width = cellSize() * cellMulti;
    height = cellSize() * cellMulti;

    final x = (index % ParsingHelper.arenaSize) * cellSize();
    final y = (index ~/ ParsingHelper.arenaSize) * cellSize();
    position = Vector2(x, y);

    // print('position: $position');
    label = TextComponent(
      // text: thisBlock.height.toString(),
      size: Vector2.all(10),
      scale: Vector2.all(0.6),
      priority: 10,
    );
    // print('cell $index mounted');
    reload();
    label!.anchor = Anchor.center;
    label!.position = Vector2(width / 2, height / 2);
    add(label!);

    listen(isClickPendingProvider, (_, bool? next) {
      if (next != null && ref.read(hoveredCellIndexProvider) == index) {
        updateState();
      }
    });

    listen(Preferences.colorCodedPrefabs, (_, __) => reload());

    listen(cellStates(index), (_, CellState? next) {
      if (next == null) return;
      updateState();
    });

    listen(gridProvider(index), (_, Cell? next) {
      if (next != null) {
        if (lastBlockData == null) {
          lastBlockData = next;
        } else if (lastBlockData == next) {
          return;
        }
        updateCellData(
          heightUpdate:
              lastBlockData == null || next.height != lastBlockData!.height,
          prefabUpdate:
              lastBlockData == null || next.prefab != lastBlockData!.prefab,
        );
        lastBlockData = next;
      }
    });

    listen(tabProvider, (_, AppTab next) {
      updateCellData(
        heightUpdate: true,
        prefabUpdate: true,
      );
    });
  }

  @override
  void onRemove() {
    if (hover != null) {
      parent?.remove(hover!);
      hover = null;
    }
    if (label != null) {
      parent?.remove(label!);
      label = null;
    }
    if (stairsIcon != null) {
      parent?.remove(stairsIcon!);
      stairsIcon = null;
    }

    super.onRemove();
  }

  void updateHeight() {
    var color = ColorHelper.heightToColor(thisBlock.height);
    setColor(color);

    updateLabelColor();
    updateStairs();
    updateState();
  }

  // label, stairs, prefab color
  void updateCellData({bool heightUpdate = false, bool prefabUpdate = false}) {
    if (heightUpdate) updateHeight();
    updateStairs();
    updateLabel();
    if (prefabUpdate) {
      updateLabelColor();
    }
  }

  void updateState() {
    updateTint();
    updateHoverBorder();
  }

  void reload() {
    updateCellData(heightUpdate: true, prefabUpdate: true);
    updateState();
  }

  void updateLabel() {
    var desiredText = '';
    if (ref.read(tabProvider) == AppTab.heights) {
      desiredText = thisBlock.height.toString();
    } else {
      desiredText = thisBlock.prefab;
    }

    if (label?.text != desiredText) {
      label?.text = desiredText;
    }
  }

  Color? prefabColor() {
    final prefab = getPrefabFromSymbol(thisBlock.prefab);
    if (prefab == Prefab.none) return null;
    return ColorHelper.prefabColors[prefab];
  }

  static List<BoxShadow> generateShadows({
    required double blurRadius,
    required double spreadRadius,
    required Color color,
    required double precision,
    required double width,
    required double height,
  }) {
    List<BoxShadow> shadows = [];
    double stepSize = 1 / precision;
    for (double x = 0; x < 1; x += stepSize) {
      for (double y = 0; y < 1; y += stepSize) {
        double dx = lerp(0, width, x);
        double dy = lerp(0, height, y);
        shadows.add(BoxShadow(
          offset: Offset(dx, dy),
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
          color: color,
        ));
      }
    }
    return shadows;
  }

  static double lerp(double min, double max, double t) {
    return min + (max - min) * t;
  }

  void updateLabelColor() {
    var textColor = ColorHelper.blockTextColor(thisBlock.height);
    final isInPrefabMode = ref.read(tabProvider) == AppTab.prefabs;
    final prefabColors = ref.read(Preferences.colorCodedPrefabs);

    if (prefabColors) {
      if (isInPrefabMode) {
        var color = prefabColor();
        if (color != null) {
          textColor = Colors.black;
          prefabIndicator.show(color);
        } else {
          if (isInPrefabMode) {
            if (thisBlock.prefab == '0') textColor = textColor.withAlpha(10);
          }
          prefabIndicator.hide();
        }
      } else {
        prefabIndicator.hide();
      }
    } else {
      if (isInPrefabMode) {
        if (thisBlock.prefab == '0') textColor = textColor.withAlpha(10);
      }
      prefabIndicator.hide();
    }

    label?.textRenderer = TextPaint(
      style: TextStyle(
        color: textColor,
        fontSize: 25,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void updateTint() {
    final isTinted = thisState.isPaintedOver;
    final enableBackgroundTint = ref.read(Preferences.brushTintEnabled);

    if (isTinted && enableBackgroundTint) {
      var color = ColorHelper.heightToColor(thisBlock.height);
      color = Color.alphaBlend(Colors.red.withOpacity(0.2), color);
      setColor(color);
    }
  }

  void createStairsIcon() {
    stairsIcon = SpriteComponent(
      sprite: stairsImage,
      size: Vector2.all(cellSize() * 0.3),
      anchor: Anchor.bottomLeft,
      position: Vector2(3, height - 3),
    );
    stairsIcon?.opacity = 0.5;
    add(stairsIcon!);
  }

  void updateStairs() {
    if (thisBlock.prefab == 's') {
      if (stairsIcon == null) {
        createStairsIcon();
        stairsIcon?.tint(ColorHelper.blockOverlayColor(thisBlock.height));
      }
    } else {
      if (stairsIcon != null) {
        remove(stairsIcon!);
        stairsIcon = null;
      }
    }
  }

  void updateHoverBorder() {
    final cellState = thisState;
    final isHovered = cellState.isHovered;

    if (isHovered) {
      if (hover == null) {
        hover = RectangleComponent(
          position: position + Vector2.all(cellSize() / 2),
          size: Vector2(width * 1.13, height * 1.13),
          anchor: Anchor.center,
          priority: 2,
        );
        parent?.add(hover!);
      }
      hover?.opacity = 1;

      if (ref.read(isClickPendingProvider)) {
        hover!.setColor(const Color.fromARGB(255, 196, 31, 20));
      } else {
        hover!.setColor(Colors.red);
      }

      priority = 3;
    } else {
      if (hover != null) {
        setColor(
          ColorHelper.heightToColor(thisBlock.height),
        );
      }
      hover?.opacity = 0;
      priority = 1;
    }
  }

  void updateForegroundColor() {
    label?.textRenderer = TextPaint(
      style: textStyle.copyWith(
        color: ColorHelper.blockTextColor(thisBlock.height),
      ),
    );
  }

  double cellSize() {
    return (gameRef.size.x / ParsingHelper.arenaSize);
  }
}
