import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatelessWidget {

  // Constructor


  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.all(15),
        child: Text(
          'Add Text',
          style: TextStyle(fontSize: 28),
          textAlign: TextAlign.center,
        ),



        );
  }
}


