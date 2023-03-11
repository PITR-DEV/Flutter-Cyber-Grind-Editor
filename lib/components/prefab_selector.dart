import 'package:cgef/helpers/color_helper.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/pref_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

import 'input/fat_button.dart';

class PrefabSelector extends ConsumerWidget {
  const PrefabSelector({Key? key}) : super(key: key);

  Widget prefabButton(Prefab prefab, List<Widget> children, WidgetRef ref,
      BuildContext context) {
    final compactLayout = context.breakpoint <= LayoutBreakpoint.sm;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        FatButton(
          onPressed: () =>
              ref.read(selectedPrefabProvider.notifier).state = prefab,
          active: ref.watch(selectedPrefabProvider) == prefab,
          noPadding: true,
          child: Row(
            children: children,
          ),
        ),
        if (ref.watch(Preferences.colorCodedPrefabs) &&
            ColorHelper.prefabColors.containsKey(prefab))
          Positioned(
            top: prefab == Prefab.none ? 16 : 20,
            left: !compactLayout ? -22 : null,
            right: compactLayout ? 12 : null,
            child: Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                color: ColorHelper.prefabColors[prefab],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Margin(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          const Text(
            'Prefabs',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            height: 12,
          ),
          prefabButton(
            Prefab.none,
            [
              Container(
                width: 12 + 52,
              ),
              const Text('None')
            ],
            ref,
            context,
          ),
          prefabButton(
            Prefab.melee,
            [
              Image.asset(
                'assets/Filth.png',
                height: 52,
                width: 52,
              ),
              Container(
                width: 12,
              ),
              const Text('Melee')
            ],
            ref,
            context,
          ),
          prefabButton(
            Prefab.projectile,
            [
              Image.asset(
                'assets/Shotgun_Husk.png',
                height: 52,
                width: 52,
              ),
              Container(
                width: 12,
              ),
              const Text('Projectile')
            ],
            ref,
            context,
          ),
          prefabButton(
            Prefab.hideous,
            [
              Image.asset(
                'assets/Hideous_Mass.png',
                height: 52,
                width: 52,
              ),
              Container(
                width: 12,
              ),
              const Text('Hideous')
            ],
            ref,
            context,
          ),
          prefabButton(
            Prefab.jumpPad,
            [
              Image.asset(
                'assets/Jump_Pad.png',
                height: 52,
                width: 52,
              ),
              Container(
                width: 12,
              ),
              const Text('Jump Pad')
            ],
            ref,
            context,
          ),
          prefabButton(
            Prefab.stairs,
            [
              Image.asset(
                'assets/Stairs.png',
                height: 52,
                width: 52,
              ),
              Container(
                width: 12,
              ),
              const Text('Stairs')
            ],
            ref,
            context,
          ),
        ],
      ),
    );
  }
}
