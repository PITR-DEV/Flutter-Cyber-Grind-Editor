import 'package:cgef/state/app_state.dart';
import 'package:cgef/widgets/prefab_selector.dart';
import 'package:cgef/widgets/tool_options.dart';
import 'package:cgef/widgets/toolbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layout/layout.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key, required this.content}) : super(key: key);
  final Widget content;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var rowChildren = <Widget>[];
    var secondaryDrawer = AppState.of(context).tab == AppTab.heights
        ? const ToolOptions()
        : const PrefabSelector();
    Widget finalLayout;

    if (context.breakpoint > LayoutBreakpoint.xs) {
      if (context.breakpoint > LayoutBreakpoint.sm) {
        rowChildren = [
          const SizedBox(
            width: 200,
            child: Toolbox(),
          ),
          Expanded(
            child: widget.content,
          ),
          SizedBox(
            width: 200,
            child: secondaryDrawer,
          ),
        ];
      } else {
        rowChildren = [
          SizedBox(
            width: 200,
            child: ListView(
              children: [
                const Toolbox(),
                secondaryDrawer,
              ],
            ),
          ),
          Expanded(
            child: widget.content,
          )
        ];
      }

      finalLayout = Scaffold(
        body: Row(
          children: rowChildren,
        ),
      );
      return Focus(
        child: RawKeyboardListener(
            focusNode: _focusNode, onKey: _handleKeyEvent, child: finalLayout),
        onFocusChange: (value) {
          if (!value) _focusNode.requestFocus();
        },
      );
    }

    finalLayout = Scaffold(
      appBar: AppBar(),
      body: widget.content,
      drawer: Drawer(
        child: ListView(
          children: [const Toolbox(), secondaryDrawer],
        ),
      ),
    );

    return Focus(
      child: RawKeyboardListener(
          autofocus: true,
          focusNode: _focusNode,
          onKey: _handleKeyEvent,
          child: finalLayout),
      onFocusChange: (value) {
        if (!value) _focusNode.requestFocus();
      },
    );
  }
}
