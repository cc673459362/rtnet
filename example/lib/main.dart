import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rtnet/rtnet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _rtnetPlugin = Rtnet();
  late StreamSubscription<String> _subscription;
  String _latestEvent = 'Waiting for events...';

  @override
  void initState() {
    super.initState();
    // 订阅原生端的事件流
    _subscription = _rtnetPlugin.eventStream.listen((event) {
      setState(() {
        _latestEvent = event;  // 更新最新的事件数据
      });
    }, onError: (error) {
        setState(() {
          _latestEvent = 'Error: $error';
        });
      },);
    initPlatformState();
  }

  @override
  void dispose() {
    _subscription.cancel();  // 取消订阅
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _rtnetPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(_latestEvent),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              //按下连接网络
              onPressed: () async {
                final int? result = await _rtnetPlugin.open('42.194.195.181', 12346);
                print('open result: $result');
              },
              child: Icon(Icons.add),
            ),
            // 发送数据
            FloatingActionButton(
              onPressed: () async {
                final int? result = await _rtnetPlugin.send('Hello, RTNET!');
                print('send result: $result');
              },
              child: Icon(Icons.send),
            ),
            // 关闭网络
            FloatingActionButton(
              onPressed: () async {
                final int? result = await _rtnetPlugin.close();
                print('close result: $result');
              },
              child: Icon(Icons.close),
            ),
            SizedBox(width: 16), // 两个按钮之间的间距
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.remove),
            ),
          ],
        ),
        //
      ),
    );
  }
}
