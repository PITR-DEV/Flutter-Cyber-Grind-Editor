import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

import 'input/fat_button.dart';

class PrefabSelector extends ConsumerWidget {
  const PrefabSelector({Key? key}) : super(key: key);

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
          FatButton(
            onPressed: () =>
                ref.read(selectedPrefabProvider.notifier).state = Prefab.none,
            active: ref.watch(selectedPrefabProvider) == Prefab.none,
            child: const Text('None'),
          ),
          FatButton(
            onPressed: () =>
                ref.read(selectedPrefabProvider.notifier).state = Prefab.melee,
            active: ref.watch(selectedPrefabProvider) == Prefab.melee,
            noPadding: true,
            child: Row(
              children: [
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
            ),
          ),
          FatButton(
            onPressed: () => ref.read(selectedPrefabProvider.notifier).state =
                Prefab.projectile,
            active: ref.watch(selectedPrefabProvider) == Prefab.projectile,
            noPadding: true,
            child: Row(
              children: [
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
            ),
          ),
          FatButton(
            onPressed: () => ref.read(selectedPrefabProvider.notifier).state =
                Prefab.jumpPad,
            active: ref.watch(selectedPrefabProvider) == Prefab.jumpPad,
            noPadding: true,
            child: Row(
              children: [
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
            ),
          ),
          FatButton(
            onPressed: () =>
                ref.read(selectedPrefabProvider.notifier).state = Prefab.stairs,
            active: ref.watch(selectedPrefabProvider) == Prefab.stairs,
            noPadding: true,
            child: Row(
              children: [
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
            ),
          ),
          FatButton(
            onPressed: () => ref.read(selectedPrefabProvider.notifier).state =
                Prefab.hideous,
            active: ref.watch(selectedPrefabProvider) == Prefab.hideous,
            noPadding: true,
            child: Row(
              children: [
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
            ),
          ),
        ],
      ),
    );
  }
}
