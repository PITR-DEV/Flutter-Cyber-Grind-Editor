import 'package:cgef/state/app_state.dart';
import 'package:cgef/widgets/input/fat_button.dart';
import 'package:cgef/widgets/input/fat_input.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:scoped_model/scoped_model.dart';

class ToolOptions extends StatefulWidget {
  const ToolOptions({Key? key}) : super(key: key);

  @override
  _ToolOptions createState() => _ToolOptions();
}

class _ToolOptions extends State<ToolOptions> {
  TextEditingController? setToFieldController;
  TextEditingController? plusFieldController;

  @override
  void dispose() {
    setToFieldController?.dispose();
    plusFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (setToFieldController == null) {
      setToFieldController = TextEditingController(
          text: AppState.of(context).setToValue.toString());
      plusFieldController = TextEditingController(
          text: AppState.of(context).plusValue.toString());
    }

    return ScopedModelDescendant<AppState>(
      builder: (context, child, model) => Margin(
        child: Column(
          children: [
            const Text(
              'Options',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Container(
              height: 12,
            ),
            FatButton(
                onPressed: () => model.setToolModifier(ToolModifier.plusOne),
                active: model.toolModifier == ToolModifier.plusOne,
                child: const Text('Plus One')),
            FatButton(
                onPressed: () => model.setToolModifier(ToolModifier.minusOne),
                active: model.toolModifier == ToolModifier.minusOne,
                child: const Text('Minus One')),
            FatButton(
                onPressed: () => model.setToolModifier(ToolModifier.setTo),
                active: model.toolModifier == ToolModifier.setTo,
                flowDown: model.toolModifier == ToolModifier.setTo,
                child: const Text('Set To')),
            model.toolModifier == ToolModifier.setTo
                ? FatInput(
                    controller: setToFieldController,
                    onChanged: (p0) =>
                        model.setToolOptions(setToValue: int.tryParse(p0)),
                  )
                : Container(),
            FatButton(
                onPressed: () => model.setToolModifier(ToolModifier.plusValue),
                active: model.toolModifier == ToolModifier.plusValue,
                flowDown: model.toolModifier == ToolModifier.plusValue,
                child: const Text('Plus')),
            model.toolModifier == ToolModifier.plusValue
                ? FatInput(
                    controller: plusFieldController,
                    onChanged: (p0) =>
                        model.setToolOptions(plusValue: int.tryParse(p0)),
                  )
                : Container(),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
