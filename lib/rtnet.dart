
import 'package:flutter/services.dart';

import 'rtnet_platform_interface.dart';

class Rtnet {
  // 数据流通道 - 用于传输二进制数据（音频、视频等）
  static const EventChannel _dataChannel = EventChannel('rtnet_data');
  
  // 状态流通道 - 用于传输状态消息（连接状态、错误信息等）
  static const EventChannel _statusChannel = EventChannel('rtnet_status');

  // 数据流 - 返回 Uint8List（二进制数据）
  Stream<Uint8List> get dataStream {
    return _dataChannel.receiveBroadcastStream().map((event) => event as Uint8List);
  }

  // 状态流 - 返回 String（状态消息）
  Stream<String> get statusStream {
    return _statusChannel.receiveBroadcastStream().map((event) => event as String);
  }

  Future<String?> getPlatformVersion() {
    return RtnetPlatform.instance.getPlatformVersion();
  }

  Future<int?> open(String ip, int port) {
    return RtnetPlatform.instance.open(ip, port);
  }

  Future<int?> send(Uint8List data) {
    return RtnetPlatform.instance.send(data);
  }

  Future<int?> close() {
    return RtnetPlatform.instance.close();
  }
}
