import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rtnet_platform_interface.dart';

/// An implementation of [RtnetPlatform] that uses method channels.
class MethodChannelRtnet extends RtnetPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rtnet');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> open(String ip, int port) async{
    return await methodChannel.invokeMethod<int>('open', <String, dynamic>{
      'ip': ip,
      'port': port,
    });
  }

  @override
  Future<int?> send(String data) {
    return methodChannel.invokeMethod<int>('send', <String, dynamic>{
      'data': data,
    });
  }

  @override
  Future<int?> close() {
    return methodChannel.invokeMethod<int>('close');
  }
}
