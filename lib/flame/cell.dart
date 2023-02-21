import 'dart:async';

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
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

class GridBlockComponent extends RectangleComponent
    with Tappable, HasGameRef, HasComponentRef {
  GridBlockComponent(this.index);
  int index = 0;

  TextComponent? text;
  RectangleComponent? hover;
  CircleComponent? prefabColorCircle;
  SvgComponent? stairsIcon;
  ColorEffect? overlayColorEffect;

  Cell? lastBlockData;

  TextStyle textStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w500,
  );

  static Svg? stairsSvg;
  static bool initialized = false;

  Cell get thisBlock => ref.read(gridProvider(index));
  CellState get thisState => ref.read(cellStates(index));
  AppTab get currentTab => ref.read(tabProvider);

  @override
  void onRemove() {
    if (hover != null) {
      parent?.remove(hover!);
      hover = null;
    }
    if (text != null) {
      parent?.remove(text!);
      text = null;
    }
    if (stairsIcon != null) {
      parent?.remove(stairsIcon!);
      stairsIcon = null;
    }

    super.onRemove();
  }

  @override
  FutureOr<void> onMount() {
    super.onMount();

    if (!initialized && stairsIcon == null) {
      Svg.load('Stairs_Map_Preview.svg').then((value) {
        stairsSvg = value;
      });
      initialized = true;
    }

    const cellMulti = 0.98;
    width = cellSize() * cellMulti;
    height = cellSize() * cellMulti;

    final x = (index % ParsingHelper.arenaSize) * cellSize();
    final y = (index ~/ ParsingHelper.arenaSize) * cellSize();
    position = Vector2(x, y);

    // print('position: $position');
    text = TextComponent(
        // text: thisBlock.height.toString(),
        size: Vector2.all(10),
        scale: Vector2.all(0.6),
        priority: 100);
    // print('cell $index mounted');
    updateCell(ref.read(tabProvider));
    text!.anchor = Anchor.center;
    text!.position = Vector2(width / 2, height / 2);
    add(text!);

    listen(isClickPendingProvider, (_, bool? next) {
      if (next != null && ref.read(hoveredCellIndexProvider) == index) {
        updateCellState();
      }
    });

    listen(Preferences.colorCodedPrefabs, (p0, p1) => updateCell(currentTab));

    listen(cellStates(index), (_, CellState? next) {
      if (next == null) return;
      updateCellState();
    });

    listen(gridProvider(index), (_, Cell? next) {
      if (next != null) {
        if (lastBlockData == null) {
          lastBlockData = next;
        } else if (lastBlockData == next) {
          return;
        }
        lastBlockData = next;
        updateCell(currentTab);
      }
    });

    listen(tabProvider, (_, AppTab next) {
      updateCell(next);
    });
  }

  void updateCellState() {
    final cellState = thisState;
    final isHovered = cellState.isHovered;

    if (isHovered) {
      if (hover == null || hover?.parent == null) {
        hover ??= RectangleComponent(
          position: position + Vector2.all(cellSize() / 2),
          size: Vector2(width * 1.13, height * 1.13),
          anchor: Anchor.center,
          priority: 50,
        );

        // move cell to top
        priority = 80;
        parent?.add(hover!);
      }

      if (ref.read(isClickPendingProvider)) {
        hover!.setColor(const Color.fromARGB(255, 196, 31, 20));
      } else {
        hover!.setColor(Colors.red);
      }
    } else {
      if (hover != null) {
        setColor(
          ColorHelper.heightToColor(thisBlock.height),
        );
        // move cell to bottom
        priority = 0;
        if (hover!.parent != null) hover!.parent!.remove(hover!);
      }
    }

    updateHeight();
  }

  void updateHeight() {
    final isTinted = thisState.isPaintedOver;
    final enableBackgroundTint = ref.read(Preferences.brushTintEnabled);
    if (isTinted && enableBackgroundTint) {
      var color = ColorHelper.heightToColor(thisBlock.height);
      color = Color.alphaBlend(Colors.red.withOpacity(0.2), color);
      setColor(color);
    } else {
      var color = ColorHelper.heightToColor(thisBlock.height);
      setColor(color);
    }
  }

  void disposeOverlayColor() {
    if (overlayColorEffect != null) {
      if (overlayColorEffect!.parent != null) {
        overlayColorEffect!.parent!.remove(overlayColorEffect!);
      }
      overlayColorEffect = null;
    }
  }

  void updateStairs() {
    if (thisBlock.prefab == 's') {
      if (stairsIcon == null) {
        if (overlayColorEffect != null) {
          if (overlayColorEffect!.parent != null) {
            overlayColorEffect!.parent!.remove(overlayColorEffect!);
          }
          overlayColorEffect = null;
        }
        overlayColorEffect = createOverlayColor();

        stairsIcon = SvgComponent(
          svg: stairsSvg!,
          size: Vector2.all(cellSize() * 0.3),
          anchor: Anchor.bottomLeft,
          position: Vector2(3, height - 3),
          paint: Paint()..color = Colors.red,
        )..add(overlayColorEffect!);
        add(stairsIcon!);
      } else {
        disposeOverlayColor();
        overlayColorEffect = createOverlayColor();
        stairsIcon!.add(overlayColorEffect!);
      }
    } else {
      disposeOverlayColor();

      if (stairsIcon != null) {
        if (stairsIcon!.parent != null) {
          stairsIcon!.parent!.remove(stairsIcon!);
        }
        stairsIcon = null;
      }
    }
  }

  ColorEffect createOverlayColor() {
    return ColorEffect(
      ColorHelper.blockOverlayColor(thisBlock.height),
      const Offset(1, 1),
      EffectController(
        duration: 0,
      ),
    );
  }

  void updateCell(AppTab activeTab) {
    updateForegroundColor();

    if (ref.read(Preferences.debugOverlay)) {
      ref.read(debugCellsUpdatedProvider.notifier).state++;
    }

    var desiredText = '';
    if (activeTab == AppTab.heights) {
      desiredText = thisBlock.height.toString();
    } else {
      desiredText = thisBlock.prefab;
    }

    if (text?.text != desiredText) {
      text?.text = desiredText;
    }

    final isInPrefabMode = ref.read(tabProvider) == AppTab.prefabs;

    updateStairs();
    var textColor = ColorHelper.blockTextColor(thisBlock.height);
    if (isInPrefabMode) {
      if (thisBlock.prefab == '0') textColor = textColor.withAlpha(10);

      if (ref.read(Preferences.colorCodedPrefabs) &&
          ColorHelper.prefabColors
              .containsKey(getPrefabFromSymbol(thisBlock.prefab))) {
        var color =
            ColorHelper.prefabColors[getPrefabFromSymbol(thisBlock.prefab)]!;

        if (prefabColorCircle == null ||
            color != prefabColorCircle?.paint.color) {
          prefabColorCircle = CircleComponent(
            radius: cellSize() * 0.3,
            anchor: Anchor.center,
            position: Vector2(width / 2, height / 2),
            priority: 120,
          );
          prefabColorCircle!.setColor(color);
          add(prefabColorCircle!);
        }
      } else {
        removeColorOverlay();
      }
    } else {
      removeColorOverlay();
    }
    text?.textRenderer = TextPaint(
      style: TextStyle(
        color: textColor,
        fontSize: 25,
        fontWeight: FontWeight.w500,
      ),
    );

    updateHeight();
  }

  void removeColorOverlay() {
    if (prefabColorCircle != null) {
      if (prefabColorCircle!.parent != null) {
        prefabColorCircle!.parent!.remove(prefabColorCircle!);
      }
      prefabColorCircle = null;
    }
  }

  void updateForegroundColor() {
    text?.textRenderer = TextPaint(
      style: textStyle.copyWith(
        color: ColorHelper.blockTextColor(thisBlock.height),
      ),
    );
  }

  double cellSize() {
    return (gameRef.size.x / ParsingHelper.arenaSize);
  }
}
