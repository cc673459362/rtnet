import 'package:flutter_test/flutter_test.dart';
import 'package:rtnet/rtnet.dart';
import 'package:rtnet/rtnet_platform_interface.dart';
import 'package:rtnet/rtnet_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRtnetPlatform
    with MockPlatformInterfaceMixin
    implements RtnetPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  
  @override
  Future<int?> close() {
    // TODO: implement close
    throw UnimplementedError();
  }
  
  @override
  Future<int?> open(String ip, int port) {
    // TODO: implement open
    throw UnimplementedError();
  }
  
  @override
  Future<int?> send(String data) {
    // TODO: implement send
    throw UnimplementedError();
  }
}

void main() {
  final RtnetPlatform initialPlatform = RtnetPlatform.instance;

  test('$MethodChannelRtnet is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRtnet>());
  });

  test('getPlatformVersion', () async {
    Rtnet rtnetPlugin = Rtnet();
    MockRtnetPlatform fakePlatform = MockRtnetPlatform();
    RtnetPlatform.instance = fakePlatform;

    expect(await rtnetPlugin.getPlatformVersion(), '42');
  });
}
