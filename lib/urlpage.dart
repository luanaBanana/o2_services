import 'dart:async';

import 'package:flutter/material.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'package:o2_services/firstwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './firstwidget.dart';
import './bottomnavigationbar.dart';
import './main.dart';

void buttonClicked() {
  print('Button Clicked');
}

class UrlPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white.withOpacity(0.0),
      ),
      width: double.infinity,
      margin: EdgeInsets.all(22),
        child: Form(
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
                    }
                  },
                  child: Text('Send'),
                ),
              ),
            ],
          ),
        ),
    );
  }
}


