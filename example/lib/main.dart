import 'dart:convert';

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
  late StreamSubscription<Uint8List> _subscription;
  final TextEditingController _controller = TextEditingController();  // 创建一个控制器
  List<Uint8List> _events = [];

  late StreamSubscription<String> _statusSubscription;

  @override
  void initState() {
    super.initState();
    _subscription = _rtnetPlugin.dataStream.listen((event) {
      setState(() {
        _events.add(event);
      });
    }, onError: (error) {
        print('数据流错误： $error');
      },);
    initPlatformState();
    _statusSubscription = _rtnetPlugin.statusStream.listen((status) {
      print('状态消息： $status');
    }, onError: (error) {
      print('状态流错误： $error');
    },);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _statusSubscription.cancel();
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
                      children: _events.map((event) { 
                        // 将 Uint8List 转换为可显示的字符串
                        String displayText;
                        if (event is Uint8List) {
                          // 方法1: 显示基本信息
                          displayText = '二进制数据: ${event.length} 字节';
                          
                          // 方法2: 显示十六进制
                          // displayText = 'Hex: ${_bytesToHex(event.sublist(0, event.length > 8 ? 8 : event.length))}';
                          
                          // 方法3: 尝试解码为字符串
                          try {
                            displayText = utf8.decode(event);
                          } catch (e) {
                            displayText = '二进制数据: ${event.length} 字节';
                          }
                        } else {
                          displayText = event.toString();
                        }
                        return Text(displayText, style: TextStyle(fontSize: 16.0));
                      }).toList(),
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
                      final int? result = await _rtnetPlugin.send(utf8.encode(message));
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
