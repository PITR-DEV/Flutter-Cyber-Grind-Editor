import 'package:cgef/components/input/tab_button.dart';
import 'package:cgef/models/enums.dart';
import 'package:cgef/providers/app_provider.dart';
import 'package:cgef/providers/grid_provider.dart';
import 'package:cgef/providers/pref_provider.dart';
import 'package:cgef/components/prefab_selector.dart';
import 'package:cgef/components/tool_options.dart';
import 'package:cgef/components/toolbox.dart';
import 'package:cgef/screens/editor_screen.dart';
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
    // List<PlatformMenuItem> menus = <PlatformMenuItem>[
    //   PlatformMenuItem(label: 'File'),
    // ];
    // WidgetsBinding.instance.platformMenuDelegate.setMenus(menus);
    // ShortcutRegistry.of(context).addAll(
    //   <ShortcutActivator, Intent>{
    //     SingleActivator(LogicalKeyboardKey.keyN, control: true):
    //         const ActivateIntent(),
    //   },
    // );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
    }
  }

  Widget collapsedDrawer() {
    return Column(
      children: [
        Toolbox(),
        ToolOptions(),
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

  @override
  Widget build(BuildContext context) {
    final mobileLayout = context.breakpoint <= LayoutBreakpoint.xs;
    final compactLayout = context.breakpoint <= LayoutBreakpoint.sm;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(0, 48),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: MenuBar(children: [
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
                        leadingIcon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Main Menu'),
                      ),
                    ),
                  ],
                  child: const Text('File'),
                ),
                MenuItemButton(
                  child: const Text('Settings'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                )

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 4),
                //   child: IconButton(
                //     icon: const Icon(Icons.settings),
                //     onPressed: () {
                //       Navigator.pushNamed(context, '/settings');
                //     },
                //   ),
                // ),
                // const SizedBox(
                //   width: 4,
                // ),
              ])),
            ],
          )),
      body: Row(
        children: [
          if (!mobileLayout && compactLayout)
            SizedBox(width: 200, child: collapsedDrawer()),
          if (!compactLayout)
            const SizedBox(
              width: 200,
              child: Toolbox(),
            ),
          Expanded(
            child: Column(
              children: [
                if (!mobileLayout) SizedBox(height: 55, child: modeTabs()),
                const Expanded(
                  child: EditorScreen(
                    key: ValueKey('editor'),
                  ),
                ),
              ],
            ),
          ),
          if (!compactLayout)
            const SizedBox(
              width: 200,
              child: ToolOptions(),
            ),
        ],
      ),
    );
    // OLD LAYOUT!

    var rowChildren = <Widget>[];
    var secondaryDrawer = ref.watch(tabProvider) == AppTab.heights
        ? const ToolOptions(key: Key('toolOptions'))
        : const PrefabSelector(key: Key('prefabSelector'));
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
