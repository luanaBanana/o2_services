import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'package:http/http.dart' as http;

final String serverToken = 'AAAAEike9qQ:APA91bG9AvlSWWaMIZy-jybRs--uMgc7Ybjz7_wavGloY3ArfrZ1eDMcj-FDt2hRUrInmIo4_872rqjHouOi7vr-IgYSqxqZH04uXJqdWJBehY_O_SwKBUiI078xkYFN2aFraaYEu3o4';


class SendNotificationView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  //TODO: add message body as class.
  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    print('We here');
    await _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'I can send notifications to other devices!!!!',
            'title': 'I send this from my emulator app YAAAHAS'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          //'to': await _firebaseMessaging.getToken(),
          "to":"/topics/all",
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }


  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your URL',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      // Process data.
                      sendAndRetrieveMessage();
                    }
                  },
                  child: Text('Send'),
                ),
              ),
            ]
        )
    );
  }
}

