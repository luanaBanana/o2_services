import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'message.dart';
import 'main.dart';

class FirebaseMessagingWidget extends StatefulWidget {
  final Function selectHandler;
  FirebaseMessagingWidget(this.selectHandler);


  @override
  _FirebaseMessagingWidgetState createState() =>
      _FirebaseMessagingWidgetState(selectHandler);
}



class _FirebaseMessagingWidgetState extends State<FirebaseMessagingWidget> {
  final Function selectHandler;
  _FirebaseMessagingWidgetState(this.selectHandler);

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
              newURL = notification['body'];
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
          newURL = notification['url'];
          selectHandler();
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final notification = message['data'];
        setState(() {
          newURL = notification['url'];
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
        children: messages.map(buildMessage).toList(),
      );

  Widget buildMessage(Message message) =>
      ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}