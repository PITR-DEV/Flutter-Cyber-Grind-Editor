import 'package:cgef/models/enums.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flame/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toolProvider = StateProvider((ref) => Tool.point);
final toolModifierProvider = StateProvider((ref) => ToolModifier.plusOne);
final selectedPrefabProvider = StateProvider((ref) => Prefab.none);
final tabProvider = StateProvider((ref) => AppTab.heights);

final setToValueProvider = StateProvider((ref) => 0);
final plusValueProvider = StateProvider((ref) => 2);

final currentCoordinateProvider = StateProvider<Vector2?>((ref) => null);

final selectedGridBlockProvider = StateProvider<int?>((ref) => null);
final hoveredCellIndexProvider = StateProvider<int?>((ref) => null);
final isClickPendingProvider = StateProvider((ref) => false);

final debugCellsUpdatedProvider = StateProvider((ref) => 0);
final debugCellsUpdatedProvider2 = StateProvider((ref) => <int>[].lock);

final pastHomeProvider = StateProvider((ref) => false);
