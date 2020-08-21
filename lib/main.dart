import 'dart:async';

import 'package:flutter/material.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'package:o2_services/firstwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './firstcolumn.dart';
import './firstwidget.dart';
import './bottomnavigationbar.dart';
import './webviewpage.dart';
import './urlpage.dart';

void main() => runApp((MyApp()));
var newURL = "https://www.wikipedia.org/";

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  void buttonClicked() {
    print('new URL: ' + newURL);
    _webViewController.loadUrl(newURL);
  }

  // BottomNavigationBar
  int _selectedPage = 0;
  final _pageOptions = [
    WebViewPage(),
    UrlPage(),
  ];

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
         //  _pageOptions[_selectedPage],

            Expanded(
              child: FirebaseMessagingWidget(buttonClicked),
            ),
            //RaisedButton(child: Text('Send URL'), onPressed: buttonClicked),
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
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[200],
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('WebView')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.send), title: Text('Send URL')),
            ]),
      ),
    );
  }
}
