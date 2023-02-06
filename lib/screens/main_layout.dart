import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:cgef/providers/pref_provider.dart';
import 'package:cgef/components/prefab_selector.dart';
import 'package:cgef/components/tool_options.dart';
import 'package:cgef/components/toolbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({Key? key, required this.content}) : super(key: key);
  final Widget content;

  @override
  createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
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
    var secondaryDrawer = ref.watch(tabProvider) == AppTab.heights
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
          children: [
            const Toolbox(),
            secondaryDrawer,
          ],
        ),
      ),
    );

    return Focus(
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        child: finalLayout,
      ),
      onFocusChange: (value) {
        if (!value) _focusNode.requestFocus();
      },
    );
  }
}
