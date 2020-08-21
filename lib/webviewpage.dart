import 'dart:async';

import 'package:flutter/material.dart';
import 'package:o2_services/firebase_messaging.dart';
import 'package:o2_services/firstwidget.dart';
import 'package:webview_flutter/webview_flutter.dart';


import './firstwidget.dart';
import './bottomnavigationbar.dart';
import './webviewpage.dart';
import './urlpage.dart';


class WebViewPage extends StatelessWidget {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {

    return Expanded(
        child: WebView(
          initialUrl: "https://www.google.com",
          onWebViewCreated: (webViewController) {
            _webViewController = webViewController;
          },
        ),
      );

  }
}
