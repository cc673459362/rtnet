
import 'package:flutter/services.dart';

import 'rtnet_platform_interface.dart';

class Rtnet {
  static const EventChannel _eventChannel = EventChannel('rtnet_event');

  // 创建一个 Stream 来接收原生端的事件数据
  Stream<String> get eventStream {
    return _eventChannel.receiveBroadcastStream().map((event) => event as String);
  }

  Future<String?> getPlatformVersion() {
    return RtnetPlatform.instance.getPlatformVersion();
  }

  Future<int?> open(String ip, int port) {
    return RtnetPlatform.instance.open(ip, port);
  }

  Future<int?> send(String data) {
    return RtnetPlatform.instance.send(data);
  }

  Future<int?> close() {
    return RtnetPlatform.instance.close();
  }
}
