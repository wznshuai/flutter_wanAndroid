import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewWidget extends StatefulWidget {
  @override
  _WebViewWidgetState createState() => new _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this);
  }
  
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: {
        "/": (_) => new WebviewScaffold(
          url: "https://www.baidu.com",
          appBar: new AppBar(
            title: new Text("Widget webview"),
          ),
        ),
      },
    );
  }
}