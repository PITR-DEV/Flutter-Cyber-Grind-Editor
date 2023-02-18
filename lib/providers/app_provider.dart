import 'package:cgef/models/enums.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flame/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async' as dart_async;

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

final filePath = StateProvider<String?>((ref) => null);

final notificationProvider = StateProvider<String?>((ref) => null);

dart_async.Timer? notificationTimer;
void showNotification(String text, WidgetRef ref) {
  final notificationNotifier = ref.read(notificationProvider.notifier);
  notificationTimer?.cancel();
  notificationTimer = dart_async.Timer(const Duration(seconds: 1), () {
    notificationNotifier.state = null;
  });

  if (notificationNotifier.state?.isNotEmpty ?? false) {
    notificationNotifier.state = null;
  }

  Future.delayed(const Duration(milliseconds: 50), () {
    notificationNotifier.state = text;
  });
}
