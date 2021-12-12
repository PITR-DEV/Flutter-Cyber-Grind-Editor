import 'package:cgef/state/app_state.dart';
import 'package:cgef/widgets/input/fat_button.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:scoped_model/scoped_model.dart';

class Toolbox extends StatelessWidget {
  const Toolbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (context, child, model) => Margin(
        child: Column(
          children: [
            const Text(
              'Toolbox',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              height: 12,
            ),
            Tooltip(
              message: 'Point',
              child: FatButton(
                onPressed: () => model.setTool(Tool.point),
                active: model.tool == Tool.point,
                child: const Icon(Icons.create_outlined),
              ),
            ),
            Tooltip(
              message: 'Brush',
              child: FatButton(
                onPressed: () => model.setTool(Tool.brush),
                active: model.tool == Tool.brush,
                child: const Icon(Icons.brush_outlined),
              ),
            ),
            Tooltip(
              message: 'Fill Rect',
              child: FatButton(
                onPressed: () => model.setTool(Tool.fillRect),
                active: model.tool == Tool.fillRect,
                child: const Icon(Icons.aspect_ratio_outlined),
              ),
            ),
            Tooltip(
                message: 'Outline Rect',
                child: FatButton(
                  onPressed: () => model.setTool(Tool.outlineRect),
                  active: model.tool == Tool.outlineRect,
                  child: const Icon(Icons.check_box_outline_blank),
                )),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
