import 'package:flutter/material.dart';
import './products/presentation/products_list_screen.dart';

void main() {
  // runApp(MaterialApp(
  //   home: ProductsListScreen(),
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.deepPurpleAccent),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Lp Inventory'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Text(
                //   'Inventory LP ',
                //   style: TextStyle(fontSize: 20),
                // ),
                Image.asset('assets/inventor.png', fit: BoxFit.cover),
                ElevatedButton(
                    onPressed: () => {
                          // olap
                        },
                    child: const Text('Iniciar',
                    style: TextStyle(fontSize: 40 )),
                    )
              ],
            ),
          ),
        ));
  }
}
