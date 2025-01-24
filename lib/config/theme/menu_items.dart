
import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title, 
    required this.subTitle,
    required this.link, 
    required this.icon});
}

const appMenuItems = <MenuItem> [
  MenuItem(
    title: 'Product List',
    subTitle: 'Inventario actual a la fecha',
    link: '/inventory',
    icon: Icons.inventory,
  ),
  MenuItem(
    title: 'Buscar productos',
    subTitle: 'Buscar por SKU',
    link: '/searchInventory',
    icon: Icons.shopping_bag,
  )
];