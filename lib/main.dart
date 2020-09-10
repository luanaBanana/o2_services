import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'package:o2_services/sendNotificationView.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'firebase_messaging.dart';
import 'model/message.dart';

//Initialize Firebase
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//Global Key for the state of the pages within bar navigation
GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

//Webview
WebViewController _webViewController;
//Webview Url
var url = "https://o2.services";

//Is user currently a sender?
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

  //Extract URL from received payload. Different depending if iOS or Android.
  String extractURL(Map<String, dynamic> message){
    if (Platform.isIOS){
      url = message['url'];
    }
    else if (Platform.isAndroid){
      var notification = message['data'];
      url = notification['url'];
    }
    print('LOG: Received URL is: $url');
    return url;
  }

  //This initializes the main app. In here we define what happens when a notification
  // is received in the different states: onLaunch, onResume, onMessage.
  @override
  void initState() {
    super.initState();
    //Subscribe to the topic "all". This is important, because it is needed when we send a notification.
    // The notification is sent to all the devices subscribed to "all"
    _firebaseMessaging.subscribeToTopic("all");
    //Firebase is configured
    _firebaseMessaging.configure(
      //On message = app is open
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          url = extractURL(message);
          //if it is the sender no alert needs to pop up
          if (isSender != true) {
            showMyDialog();
          } else {
            isSender = false;
          }
        });
      },
      // On Launch = open the app from a terminated state.
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        setState(() {
          url = extractURL(message);
          showMyDialog();
        });
      },
      //onBackgroundMessage: Not used yet. Can be implemented if needed.
      onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
      // onResume: open app from background.
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        setState(() {
          url = extractURL(message);
          showMyDialog();
        });
      },
    );

    //Request the notification for iOS -> only needed for iOS.
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
            //Add children widget if needed
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
              //Add items if needed
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('WebView')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.send), title: Text('Send URL'))
            ]),
      ),
    );
  }

  // BottomNavigationBar
  int _currentIndex = 0; // current index 0 is the 1 page of the bottomNavigation bar. and so on.
  // list of pages, items can be added if needed (make sure to also add a BottomNavigationBarItem)
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

  //This is what happens when you click on one of the bottom navigation bar items
  // -> index is changed meaning another page will be opened and the webview will reload.
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _webViewController.loadUrl(url);
    });
  }
}

//This is currently not needed, but can be implemented if needed.
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  //DO WORK
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
              //this makes the aler go away
              Navigator.of(context).pop();
              //onTabTapped(Icons.home);
            },
          ),
          FlatButton(
            child: Text('Deny'),
            onPressed: () {
              //this makes the aler go away
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
