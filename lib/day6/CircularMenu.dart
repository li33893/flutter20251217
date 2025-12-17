import 'package:flutter/material.dart';
import 'package:circular_menu/circular_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Circularmenu()
    );
  }
}

class Circularmenu extends StatefulWidget {
  const Circularmenu({super.key});

  @override
  State<Circularmenu> createState() => _CircularmenuState();
}

class _CircularmenuState extends State<Circularmenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircularMenu(
          alignment: Alignment.center,
          toggleButtonColor:Colors.greenAccent,
          items: [
            CircularMenuItem(icon: Icons.home, onTap: () {
              // callback
            }),
            CircularMenuItem(icon: Icons.search, onTap: () {
              //callback
            }, color:Colors.green[200]),
            CircularMenuItem(icon: Icons.settings, onTap: () {
              //callback
            }),
            CircularMenuItem(icon: Icons.star, onTap: () {
              //callback
            }),
            CircularMenuItem(icon: Icons.pages, onTap: () {
              //callback
            }),
          ])

    );
  }
}
