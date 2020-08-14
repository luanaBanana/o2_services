import 'package:flutter/material.dart';
import 'package:o2_services/webview.dart';
import 'package:flutter_launcher_icons/android.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:flutter_launcher_icons/custom_exceptions.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

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
            WebView()
          ],
        ),
      ),
    );
  }
}
