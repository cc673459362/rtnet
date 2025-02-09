import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'rtnet_method_channel.dart';

abstract class RtnetPlatform extends PlatformInterface {
  /// Constructs a RtnetPlatform.
  RtnetPlatform() : super(token: _token);

  static final Object _token = Object();

  static RtnetPlatform _instance = MethodChannelRtnet();

  /// The default instance of [RtnetPlatform] to use.
  ///
  /// Defaults to [MethodChannelRtnet].
  static RtnetPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RtnetPlatform] when
  /// they register themselves.
  static set instance(RtnetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> open(String ip, int port) {
    throw UnimplementedError('open() has not been implemented.');
  }

  Future<int?> send(String data) {
    throw UnimplementedError('send() has not been implemented.');
  }

  Future<int?> close() {
    throw UnimplementedError('close() has not been implemented.');
  }
}
