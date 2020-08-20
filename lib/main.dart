import 'dart:async';

import 'package:flutter/material.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'package:o2_services/firstwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './firstcolumn.dart';
import './firstwidget.dart';

void main() => runApp((MyApp()));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  void buttonClicked() {
    var newurl = "https://www.wikipedia.org/";
    _webViewController.loadUrl(newurl);
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewController _webViewController;

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
            Expanded(
              child: FirebaseMessagingWidget(buttonClicked),
            ),
            RaisedButton(child: Text('Send URL'), onPressed: buttonClicked),
            Expanded(
              child: WebView(
                initialUrl: "https://www.google.com/",
                onWebViewCreated: (webViewController) {
                  _webViewController = webViewController;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
