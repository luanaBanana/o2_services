import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:o2_services/sendNotificationView.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'firebase_messaging.dart';
import 'model/message.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
WebViewController _webViewController;
var url = "https://google.com/";
bool showLoading = false;




class MyApp extends StatefulWidget {
  static final navKey = new GlobalKey<NavigatorState>();
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  final List<Message> messages = [];

  void changeURL(String url) {
    print('new URL: ' + url);
    setState(() {
      _webViewController.loadUrl(url);
    });
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.subscribeToTopic("all");

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          final notification = message['notification'];
          setState(() {
            url = notification['body'];
            print('LOG: url on message: $url');
            changeURL(url);
          });
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          final notification = message['data'];
          setState(() {
            print("onLaunch 2: $message");
            messages.add(Message(
              title: '${notification['url']}',
              body: '${notification['url']}',
            ));
            url = notification['url'];
            changeURL(url);
          });
        },
        onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          final notification = message['data'];
          setState(() {
            url = notification['url'];
            changeURL(url);
          });
        },
      );


    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey:MyApp.navKey,
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
              child: _pageOptions[_currentIndex],
            ),
          ],
        ),


        bottomNavigationBar: BottomNavigationBar(
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
      }
      ),
    SendNotificationView(_firebaseMessaging),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      changeURL(url);
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

  }




  // Or do other work.
}

Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}