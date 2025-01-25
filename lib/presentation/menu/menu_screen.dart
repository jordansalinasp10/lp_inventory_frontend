import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lp_inventory_frontend/config/menu/menu_items.dart';

class menuScreen extends StatelessWidget {
  const menuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: const _MenuView(),
    );
  }
}

class _MenuView extends StatelessWidget {
  const _MenuView();

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: appMenuItems.length,
      itemBuilder:  (context, index) {
        final menuItem = appMenuItems[index];
        return _CustomListTitle(menuItem: menuItem);
      }
    );
  }
}

class _CustomListTitle extends StatelessWidget {
  const _CustomListTitle({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(menuItem.icon),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap: () => {
        context.push(menuItem.link)
      },
    );
  }
}