import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[500]),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Wordpair Generator"),
        ),
      ),
    );
  }
}