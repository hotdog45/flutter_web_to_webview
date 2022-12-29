import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _counter = "";

  void _incrementCounter() {}
  void bindJS() { //window.callHello('Flutter'); 与js 交互
    js_util.setProperty(html.window, "callHello", js.allowInterop((args) {
      return '$args from dart';
    }));


    js_util.setProperty(html.window, "callHelloAsync",
        js.allowInterop((returnName, arg) async {
          // do some thing async
          print(arg); // 接收参数
          await Future.delayed(Duration(milliseconds: 1000));
          js.context.callMethod(returnName, ['Result from Dart']);
        }));

  }
  @override
  Widget build(BuildContext context) {
    js.context["flutterMethod"] = flutterMethod;
    js.context["flutterMethod2"] = flutterMethod2;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '第111111次测试',
            ),
            Text(
              _counter,
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
                onPressed: () {
                  //✅
                  js_util.callMethod(html.window, "app", ["12213212"]);
                },
                child: const Text("test 00000")),
            TextButton(
                onPressed: () {
                  //✅
                  js.context.callMethod("app", ["toast&张三李四王麻子&82"]);
                },
                child: const Text("test 333")),
            TextButton(
                onPressed: () {//✅
                  js.context.callMethod("alert", ["dart方法被调用了"]);
                },
                child: const Text("test 2")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void flutterMethod2(test) {
    _counter = "dart 方法被调用 $test";
    setState(() {});
  }

  void flutterMethod() {
    _counter = "dart 方法被调用";
    setState(() {});
  }
}
