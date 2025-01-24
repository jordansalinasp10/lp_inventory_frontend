import 'package:flutter/material.dart';
import 'package:lp_inventory_frontend/presentation/screens/home/home_screen.dart';
import 'presentation/products/products_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.deepPurpleAccent),
        home: HomeScreen()
    );
  }
}
