import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {

  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}




class _CounterScreenState extends State<CounterScreen> {

  int clickCounter = 0;
  var click = 'Clicks';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter Screen"),
        
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text(
            "$clickCounter",
            style: const TextStyle(fontSize: 160, fontWeight: FontWeight.w100),
          ),
          Text(
            click,
            style: TextStyle(fontSize: 30),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            clickCounter++;
            if (clickCounter == 1){
              click = 'Click';
            }
            else {
              click = 'Clicks';
            }
          });
          
        },
        child: const Icon(Icons.plus_one),
      ),
    );
  }
}
