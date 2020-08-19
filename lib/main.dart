import 'dart:async';

import 'package:flutter/material.dart';
import 'package:o2_services/firstwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import './firstwidget.dart';
import './firstcolumn.dart';

void main() => runApp((MyApp()));

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  void buttonClicked(){
    print ('The Button was clicked');
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'O2.services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('O2.services'),
          ),
          body: Column(
           children: <Widget>[
              //TODO: Add Widgets -> add new files if you add new widgets.
             FirstWidget(),
             FirstColumn(),
              RaisedButton(child: Text('Send URL'), onPressed: buttonClicked),
              Expanded(
                child: WebView(
                  initialUrl: "https://www.google.com/",
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
