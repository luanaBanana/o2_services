import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'package:o2_services/sendNotificationView.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'firebase_messaging.dart';
import 'model/message.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
WebViewController _webViewController;
var url = "https://o2.services";
bool showLoading = false;
bool isSender = false;

void main() => runApp((MyApp()));

class MyApp extends StatefulWidget {
  static final navKey = new GlobalKey<NavigatorState>();

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final List<MyMessage> messages = [];

  void changeURL(String url) {
    print('new URL: ' + url);
    setState(() {
      _webViewController.loadUrl(url);
    });
  }

  String extractURL(Map<String, dynamic> message){
    if (Platform.isIOS){
      url = message['url'];
    }
    else if (Platform.isAndroid){
      var notification = message['notification'];
      url = notification['body'];
    }
    return url;
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        url = extractURL(message);
        print('LOG: Received URL is: $url');
        setState(() {
          if (isSender != true) {
            showMyDialog();
          } else {
            isSender = false;
          }
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
        setState(() {
          print("onLaunch 2: $message");
          url = notification['url'];
          showMyDialog();
        });
      },
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final notification = message['data'];
        setState(() {
          url = notification['url'];
          showMyDialog();
        });
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navKey,
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
            Expanded(
              child: FirebaseMessagingWidget(messages),
            ),
            Expanded(
              flex: 10,
              child: IndexedStack(
                index: _currentIndex,
                children: _pageOptions,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            key: navBarGlobalKey,
            backgroundColor: Colors.grey[200],
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('WebView')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.send), title: Text('Send URL'))
            ]),
      ),
    );
  }

  // BottomNavigationBar
  int _currentIndex = 0;
  final List<Widget> _pageOptions = [
    WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (webViewController) {
        _webViewController = webViewController;
      },
    ),
    SendNotificationView(_firebaseMessaging),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _webViewController.loadUrl(url);
    });
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print('We here 1');
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('We here 2');
  } // Or do other work.
}

Future<void> showMyDialog() async {
  return showDialog<void>(
    context: MyApp.navKey.currentState.overlay.context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('You received a new URL :)'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Your peer wants to open: $url'),
              Text('Would you like to open it in the WebView?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Allow'),
            onPressed: () {
              final BottomNavigationBar navigationBar =
                  navBarGlobalKey.currentWidget;
              navigationBar.onTap(0);
              _webViewController.loadUrl(url);
              Navigator.of(context).pop();
              //onTabTapped(Icons.home);
            },
          ),
          FlatButton(
            child: Text('Deny'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
