import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'model/message.dart';
import 'main.dart';
import 'package:http/http.dart' as http;


class FirebaseMessagingWidget extends StatefulWidget {
  final Function selectHandler;
  FirebaseMessagingWidget(this.selectHandler);

  @override
  FirebaseMessagingWidgetState createState() =>
      FirebaseMessagingWidgetState(selectHandler);
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
      ListView(
        children:
        messages.map(buildMessage).toList(),
      );

  Widget buildMessage(Message message)=>
      ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}