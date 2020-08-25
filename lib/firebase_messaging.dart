import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'model/message.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';



class FirebaseMessagingWidget extends StatefulWidget {
  final Function selectHandler;
  FirebaseMessagingWidget(this.selectHandler);

  @override
  FirebaseMessagingWidgetState createState() =>
      FirebaseMessagingWidgetState(selectHandler);


}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    url = data['url'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    url = notification['url'];
  }

  // Or do other work.
}

class FirebaseMessagingWidgetState extends State<FirebaseMessagingWidget> {
  final Function selectHandler;
  FirebaseMessagingWidgetState(this.selectHandler);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];



  @override
  void initState() {
    super.initState();
    _firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
              url = notification['body'];
              selectHandler();
        });
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['url']}',
            body: '${notification['url']}',
          ));
          url = notification['url'];
          selectHandler();
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final notification = message['data'];
        setState(() {
          url = notification['url'];
          selectHandler();
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) =>
       Text('Current Url: $url');
}