import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugOverlay extends ConsumerWidget {
  const DebugOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IgnorePointer(
      child: Text(
        'tab: ${ref.watch(tabProvider)}\n'
        'tool: ${ref.watch(toolProvider)}\n'
        'toolModifier: ${ref.watch(toolModifierProvider)}\n'
        'selectedPrefab: ${ref.watch(selectedPrefabProvider)}\n'
        'pastHome: ${ref.watch(pastHomeProvider)}\n'
        'hovered: ${ref.watch(hoveredCellIndexProvider)}\n'
        'hoverEffect: [${ref.watch(hoveredProvider).join(', ')}]\n'
        'isPainting: ${ref.watch(isPaintingProvider)}\n'
        'painted: [${ref.watch(paintedOverProvider).join(', ')}]\n'
        'isClickPending: ${ref.watch(isClickPendingProvider)}\n'
        'updated: ${ref.watch(debugCellsUpdatedProvider)}\n'
        'updatedLit: [${ref.watch(debugCellsUpdatedProvider2).join(', ')}]\n',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          backgroundColor: Colors.black.withAlpha(170),
        ),
      ),
    );
  }
}
