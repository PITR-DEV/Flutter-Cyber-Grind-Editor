import 'package:cgef/components/input/tab_button.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:cgef/components/prefab_selector.dart';
import 'package:cgef/components/tool_options.dart';
import 'package:cgef/components/toolbox.dart';
import 'package:cgef/components/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
    // ShortcutRegistry.of(context).dispose();
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

  Widget collapsedDrawer() {
    return ListView(
      children: [
        const Toolbox(),
        Divider(),
        secondaryDrawer(),
      ],
    );
  }

  Widget modeTabs() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabButton(
          onPressed: () {
            ref.read(tabProvider.notifier).state = AppTab.heights;
            ref.read(selectedGridBlockProvider.notifier).state = null;
          },
          active: ref.watch(tabProvider) == AppTab.heights,
          expandVertically: ref.watch(tabProvider) == AppTab.heights,
          text: 'Heights',
          // collapsed: !gridCentered,
          collapsedIcon: const Icon(Icons.height),
        ),
        TabButton(
          onPressed: () {
            ref.read(tabProvider.notifier).state = AppTab.prefabs;
            ref.read(selectedGridBlockProvider.notifier).state = null;
          },
          active: ref.watch(tabProvider) == AppTab.prefabs,
          expandVertically: ref.watch(tabProvider) == AppTab.prefabs,
          text: 'Prefabs',
          // collapsed: !gridCentered,
          collapsedIcon: const Icon(Icons.widgets),
        ),
        // TabButton(
        //   // onPressed: export,
        //   text: 'Export',
        //   // collapsed: !gridCentered,
        //   expandVertically: false,
        //   collapsedIcon: const Icon(Icons.save),
        // )
      ],
    );
  }

  Widget secondaryDrawer() {
    return ref.watch(tabProvider) == AppTab.heights
        ? const ToolOptions(key: Key('toolOptions'))
        : const PrefabSelector(key: Key('prefabSelector'));
  }

  @override
  Widget build(BuildContext context) {
    final mobileLayout = context.breakpoint <= LayoutBreakpoint.xs;
    final compactLayout = context.breakpoint <= LayoutBreakpoint.sm;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(0, 48),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MenuBar(
                style: MenuStyle(
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.surface,
                  ),
                  side: MaterialStateProperty.all(
                    BorderSide(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(60),
                    ),
                  ),
                ),
                children: [
                  const MenuItemButton(
                    child: Text('cgef'),
                  ),
                  SubmenuButton(
                    menuChildren: [
                      SizedBox(
                        width: 280,
                        child: MenuItemButton(
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.keyN,
                            control: true,
                          ),
                          onPressed: () {
                            newPattern(ref);
                          },
                          leadingIcon: const Icon(Icons.clear_all),
                          child: const Text('New'),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: MenuItemButton(
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.keyS,
                            control: true,
                          ),
                          onPressed: () {
                            // ref.read(gridProvider.notifier).newGrid();
                          },
                          leadingIcon: const Icon(Icons.save),
                          child: const Text('Save'),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: MenuItemButton(
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.keyS,
                            control: true,
                            shift: true,
                          ),
                          onPressed: () {
                            // ref.read(gridProvider.notifier).newGrid();
                          },
                          leadingIcon: const Icon(Icons.save_alt),
                          child: const Text('Save As'),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: 280,
                        child: MenuItemButton(
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.escape,
                          ),
                          leadingIcon: const Icon(Icons.exit_to_app),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Main Menu'),
                        ),
                      ),
                    ],
                    child: const Text('File'),
                  ),
                  SubmenuButton(
                    menuChildren: [
                      SizedBox(
                        width: 280,
                        child: MenuItemButton(
                          shortcut: const SingleActivator(
                            LogicalKeyboardKey.keyZ,
                            control: true,
                          ),
                          leadingIcon: const Icon(Icons.undo),
                          onPressed: () {
                            newPattern(ref);
                          },
                          child: const Text('Undo'),
                        ),
                      ),
                      const SizedBox(
                        width: 280,
                        child: MenuItemButton(
                          shortcut: SingleActivator(
                            LogicalKeyboardKey.keyY,
                            control: true,
                          ),
                          leadingIcon: Icon(Icons.redo),
                          // onPressed: () {
                          //   // ref.read(gridProvider.notifier).newGrid();
                          // },
                          child: Text('Redo'),
                        ),
                      ),
                    ],
                    child: const Text('Edit'),
                  ),
                  MenuItemButton(
                    child: const Text('Settings'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          if (!mobileLayout && compactLayout)
            SizedBox(width: 220, child: collapsedDrawer()),
          if (!compactLayout)
            const SizedBox(
              width: 220,
              child: Toolbox(),
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!mobileLayout)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(height: 55, child: modeTabs()),
                  ),
                const Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Editor(
                        key: ValueKey('editor'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
          if (!compactLayout)
            SizedBox(
              width: 220,
              child: secondaryDrawer(),
            ),
        ],
      ),
    );
    // OLD LAYOUT!

    var rowChildren = <Widget>[];
    Widget finalLayout;

    if (context.breakpoint > LayoutBreakpoint.xs) {
      if (context.breakpoint > LayoutBreakpoint.sm) {
        rowChildren = [
          const SizedBox(
            width: 200,
            child: Toolbox(),
          ),
          // Expanded(
          // child: widget.content,
          // ),
          const SizedBox(
            width: 200,
            // child: secondaryDrawer,
          ),
        ];
      } else {
        rowChildren = [
          SizedBox(
            width: 200,
            child: ListView(
              children: const [
                Toolbox(),
                // secondaryDrawer,
              ],
            ),
          ),
          // Expanded(
          // child: widget.content,
          // )
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
      // body: widget.content,
      drawer: Drawer(
        child: ListView(
          children: const [
            Toolbox(),
            // secondaryDrawer,
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
