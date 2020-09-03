import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'main.dart';

class WebviewPage extends StatefulWidget {
  final String url;

  WebviewPage({
    @required this.url,
  });

  @override
  State<StatefulWidget> createState() {
    return WebviewPageState(url: url);
  }
}

class WebviewPageState extends State<WebviewPage> {
  //final Function updateLoading;
  final String url;

  WebviewPageState({
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        key: key,
        onPageFinished: doneLoading,
        onPageStarted: startLoading,
      },
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (webViewController) {
        webViewController = webViewController;
      },
    );
  }
}