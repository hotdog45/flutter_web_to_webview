import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

bool isClearCache = false;

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  var initialUrl = "";
  double value = 0;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) {
    //   WebView.platform = SurfaceAndroidWebView();
    // }
    print("原始Url==>${widget.url}");
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

              value = progress / 100;
              setState(() {});

          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {

            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'APP',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // _controller.runJavascript("willPopPage();");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("test html"),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Stack(
              children: <Widget>[
                Builder(builder: (BuildContext context) {
                  return WebViewWidget(
                    controller: _controller,
                  );
                }),
                if (value != 1)
                  LinearProgressIndicator(
                      value: value,
                      minHeight: 1,
                      color: Colors.green,
                      backgroundColor: Colors.transparent),

                Container(
                  padding: EdgeInsets.only(top: 60),
                  child: Row(
                    children: [
                      TextButton(onPressed: (){
                        _controller.runJavaScript("window.flutterMethod();");
                      }, child: const Text("test 1")),
                      TextButton(onPressed: (){
                        _controller.runJavaScript("window.flutterMethod2('我是原生flutter');");
                      }, child: const Text("test 2")),

                      TextButton(onPressed: (){
                        _controller.runJavaScript("APP.postMessage('toast&张三李四王麻子&82');");
                      }, child: const Text("test web 调用flutter")),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
        // floatingActionButton: !kReleaseMode
        //     ? FloatingActionButton(
        //         child: const Icon(Icons.backspace_outlined),
        //         onPressed: () {
        //           // _controller.runJavascript("APP.postMessage('toast&张三李四王麻子&82');");
        //           // _controller.runJavascript(  "APP.postMessage('openFlutterPage&acceptOrder');");
        //           // _onAddToCache(_controller, context);
        //           // _onListCache(_controller, context);
        //           // Get.back();
        //           // Get.to();
        //           Navigator.pop(context);
        //         },
        //       )
        //     : Container(),
      ),
    );
  }

  // JavaScriptMessage _appJavascriptChannel(BuildContext context) {
  //   return JavaScriptMessage(
  //       name: 'APP',
  //       onMessageReceived: (JavascriptMessage message) async {
  //         if (message.message.isNotEmpty) {
  //           var data = message.message.split("&");
  //           print("H5调用flutter===>   " + message.message);
  //           String event = data[0];
  //
  //           if (event == "logger.i") {
  //             print(data[1]);
  //           } else if (event == "logger.e") {
  //             print(data[1]);
  //           } else if (event == "toast") {
  //           } else {
  //             print("未知事件....");
  //           }
  //         }
  //       });
  // }
}
