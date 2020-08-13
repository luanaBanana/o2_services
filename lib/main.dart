import 'package:flutter/material.dart';

void main() => runApp((MyApp()));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('o2.services'),
          backgroundColor: Color(0xFF47AFFF),
        ),
        body: Column(
          children: [
            //TODO: Add Widgets -> add new files if you add new widgets.
            Text('Hello World'),
            Text('Ich bin Text 2'),
          ],
        ),
      ),
    );
  }
}
