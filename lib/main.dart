import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurpleAccent
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lp Inventory'),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Text('Initial ',
              style: TextStyle(fontSize: 30),)
          ]
          ,),
      ),
      )
    );
  }

}