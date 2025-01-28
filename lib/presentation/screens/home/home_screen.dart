import 'package:flutter/material.dart';
import 'package:lp_inventory_frontend/config/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lp Inventory'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/inventor.png', fit: BoxFit.cover),
            ElevatedButton(
              onPressed: () => {
                runApp(MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: appRouter
                ))
              },
              child: const Text('Iniciar', style: TextStyle(fontSize: 40)),
            )
          ],
        ),
      ),
    );
  }
}