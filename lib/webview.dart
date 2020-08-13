import 'package:flutter/material.dart';

class WebView extends StatelessWidget {

  // Constructor
  WebView();

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
