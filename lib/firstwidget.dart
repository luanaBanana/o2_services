import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.blue,
        ),
      width: double.infinity,
      margin: EdgeInsets.all(20),
        child: Text('This is Google Font Lato \n and our firstWidget', style: GoogleFonts.lato(fontSize: 26,),
        textAlign: TextAlign.center,)
    );
  }
}
