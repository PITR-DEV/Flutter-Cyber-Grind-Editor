import 'package:cgef/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:scoped_model/scoped_model.dart';

import 'input/fat_button.dart';

class PrefabSelector extends StatelessWidget {
  const PrefabSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (context, child, model) => Margin(
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
              onPressed: () => model.setPrefab(Prefab.none),
              active: model.selectedPrefab == Prefab.none,
              child: const Text('None'),
            ),
            FatButton(
              onPressed: () => model.setPrefab(Prefab.melee),
              active: model.selectedPrefab == Prefab.melee,
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
              onPressed: () => model.setPrefab(Prefab.projectile),
              active: model.selectedPrefab == Prefab.projectile,
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
              onPressed: () => model.setPrefab(Prefab.jumpPad),
              active: model.selectedPrefab == Prefab.jumpPad,
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
              onPressed: () => model.setPrefab(Prefab.stairs),
              active: model.selectedPrefab == Prefab.stairs,
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
              onPressed: () => model.setPrefab(Prefab.hideous),
              active: model.selectedPrefab == Prefab.hideous,
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
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
