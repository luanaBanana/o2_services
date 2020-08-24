import 'dart:async';

import 'package:flutter/material.dart';
import 'package:o2_services/sendNotificationView.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'firebase_messaging.dart';

void main() => runApp((MyApp()));
var url = "https://www.google.com/";

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}
WebViewController _webViewController;

class _MyAppState extends State<MyApp> {

  void buttonClicked() {
    setState(() {
      print('new URL: ' + url);
      _webViewController.loadUrl(url);
    });
  }

  // BottomNavigationBar
  int _currentIndex = 0;
  final List<Widget> _pageOptions = [
    WebView(
      initialUrl: url,
      onWebViewCreated: (webViewController) {
        _webViewController = webViewController;
      },
    ),
    SendNotificationView(),
    Text("Test View"),
  ];


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
          children: [
            SizedBox(
              height: 100.0,
              child: FirebaseMessagingWidget(buttonClicked),
            ),
            SizedBox(
              height: 300.0,
              child: _pageOptions[_currentIndex],
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey[200],
            currentIndex: 0,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('WebView')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.send), title: Text('Send URL')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.send), title: Text('Test')),
            ]),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


}
