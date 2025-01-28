import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem(
      {required this.title,
      required this.subTitle,
      required this.link,
      required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Inventory',
    subTitle: 'Completed and updated inventory',
    link: '/inventory',
    icon: Icons.inventory,
  ),
  MenuItem(
    title: 'Create product',
    subTitle: 'Add a product',
    link: '/createProduct',
    icon: Icons.shopping_bag,
  ),
  MenuItem(
    title: 'Text connection',
    subTitle: 'Test basic with backend',
    link: '/test',
    icon: Icons.psychology_alt_outlined,
  )
];
