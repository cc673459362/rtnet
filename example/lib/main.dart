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
  final TextEditingController _controller = TextEditingController();  // 创建一个控制器
  List<String> _events = [];

  @override
  void initState() {
    super.initState();
    _subscription = _rtnetPlugin.eventStream.listen((event) {
      setState(() {
        _events.add("[received:]" + event);
      });
    }, onError: (error) {
        setState(() {
         _events.add('Error: $error');
        });
      },);
    initPlatformState();
  }

  @override
  void dispose() {
    _subscription.cancel();
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
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    final int? result = await _rtnetPlugin.open('42.194.195.181', 12346);
                    print('open result: $result');
                  },
                  child: Text('connect'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final int? result = await _rtnetPlugin.close();
                    print('close result: $result');
                  },
                  child: Text('close'),
                ),
              ],
            ),
            SizedBox(
              height: 200.0,
              width: 400.0,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _events.map((event) => Text(event, style: TextStyle(fontSize: 16.0))).toList(),
                    ),
                  ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'please input message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      final String message = _controller.text;
                      final int? result = await _rtnetPlugin.send(message);
                      print('send result: $result');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
