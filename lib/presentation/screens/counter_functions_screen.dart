import 'package:flutter/material.dart';

class CounterFunctionScreen extends StatefulWidget {

  const CounterFunctionScreen({super.key});

  @override
  State<CounterFunctionScreen> createState() => _CounterFunctionScreenState();
}




class _CounterFunctionScreenState extends State<CounterFunctionScreen> {

  int clickCounter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter Function"),
        actions: [
          IconButton(
          onPressed: () {
            setState(() {
              clickCounter = 0;
            });
          }, icon: Icon(Icons.refresh_rounded)),]
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
            'Click${clickCounter == 1 ? '': 's'}',
            style: const TextStyle(fontSize: 30),
          )
        ],
      )),
      floatingActionButton: Column(
        
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton( icon: Icons.refresh_outlined,

          onPressed: () {
            setState(() {
              clickCounter=0;
            });
          },),
      const SizedBox(height: 10),
      CustomButton(icon: Icons.plus_one,
      onPressed: () {
        clickCounter++;
        setState(() {
          
        });
      },),
      const SizedBox(height: 10),
      CustomButton(icon: Icons.exposure_minus_1,
      onPressed: () {
        setState(() {
          if(clickCounter==0) return;
          clickCounter--;
        });
      },)
            ],
      )
    ); 
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const CustomButton({
    super.key, 
    required this.icon,
     this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
            enableFeedback: true,
            shape: StadiumBorder(),
            onPressed: onPressed,
            child: Icon(icon),
          );
  }
}
