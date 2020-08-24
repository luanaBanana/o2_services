import 'dart:async';

import 'package:flutter/material.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'package:o2_services/firstwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './firstcolumn.dart';
import './firstwidget.dart';
import './bottomnavigationbar.dart';

class UrlPage extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Multi Page Application"),
        ),
        body: new Checkbox(
            value: false,
            onChanged: null
        )
    );
  }
}