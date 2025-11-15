#import "RtnetPlugin.h"
#import "NetworkManager.h"

@interface RtnetPlugin () <NetworkManagerDelegate>
@property (nonatomic, strong) FlutterEventSink dataEventSink;    // 数据事件回调
@property (nonatomic, strong) FlutterEventSink statusEventSink;  // 状态事件回调
@property(nonatomic, strong) NetworkManager *netClient;
@end

@implementation RtnetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  NSLog(@"registerWithRegistrar");
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"rtnet" binaryMessenger:[registrar messenger]];
  // Data EventChannel - 用于二进制数据传输
  FlutterEventChannel *dataEventChannel =
      [FlutterEventChannel eventChannelWithName:@"rtnet_data"
                                binaryMessenger:[registrar messenger]];
  
  // Status EventChannel - 用于状态消息传输  
  FlutterEventChannel *statusEventChannel =
      [FlutterEventChannel eventChannelWithName:@"rtnet_status"
                                binaryMessenger:[registrar messenger]];

  RtnetPlugin *instance = [[RtnetPlugin alloc] init];
  // 初始化网络
  [instance initNetClient];
  [registrar addMethodCallDelegate:instance channel:channel];
  // 分别注册两个流的处理器
  [dataEventChannel setStreamHandler:instance];
  [statusEventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"open" isEqualToString:call.method]) {
    NSLog(@"open with args: %@ %@", call.arguments[@"ip"], call.arguments[@"port"]);
    int ret = [self open:call.arguments[@"ip"] port:call.arguments[@"port"]];
    result([NSNumber numberWithInt:ret]);
  } else if ([@"send" isEqualToString:call.method]) {
    NSLog(@"send with args: %@", call.arguments[@"data"]);
    FlutterStandardTypedData *flutterData = call.arguments[@"data"];
    NSData *nativeData = flutterData.data; // 转换为NSData
    int ret = [self send:nativeData];
    result([NSNumber numberWithInt:ret]);
  } else if ([@"close" isEqualToString:call.method]) {
    int ret = [self close];
    result([NSNumber numberWithInt:ret]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - FlutterStreamHandler 协议实现

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  // 保存事件回调
  NSLog(@"onListenWithArguments - 通道: %@", arguments);
  
  // 根据通道名称区分是数据流还是状态流
  if ([arguments isEqualToString:@"rtnet_data"]) {
    self.dataEventSink = events;
    NSLog(@"数据流监听已建立");
  } else if ([arguments isEqualToString:@"rtnet_status"]) {
    self.statusEventSink = events;
    NSLog(@"状态流监听已建立");
  }
  
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    NSLog(@"onCancelWithArguments - 通道: %@", arguments);
  
  if ([arguments isEqualToString:@"rtnet_data"]) {
    self.dataEventSink = nil;
    NSLog(@"数据流监听已取消");
  } else if ([arguments isEqualToString:@"rtnet_status"]) {
    self.statusEventSink = nil;
    NSLog(@"状态流监听已取消");
  }
  
  return nil;
}

#pragma mark - 网络客户端方法

- (void)initNetClient {
  // 创建网络客户端
  NSLog(@"initNetClient");
  self.netClient = [[NetworkManager alloc] initNetworkManagerWithDelegate:self];
}

- (int)open:(NSString *)ip port:(NSString* )port {
  // 打开连接
  NSLog(@"open: %@, %@", ip, port);
  [self.netClient open:ip port:port];
    return 0;
}

- (int)send:(NSData *)data {
  // 发送数据
  NSLog(@"send: %@", data);
  return [self.netClient send:data];
}

- (int)close {
  // 关闭连接
   [self.netClient close];
    return 0;
}

- (void)onOpen {
  NSLog(@"[rtnet]: onOpen");
  [self callbackStatus:@"open success"];
}

- (void)onReceiveData:(NSData *)data {
  NSLog(@"[rtnet]: onReceiveData %@", data);
 [self callbackData:data];
}

- (void)onError:(NSError *)error {
  NSLog(@"[rtnet]: onError %@", error);
  [self callbackStatus:error.localizedDescription];
}

// 回调状态消息到 Flutter
- (void)callbackStatus:(NSString *)status {
  if (self.statusEventSink) {
    self.statusEventSink(status);
    NSLog(@"[rtnet]回调状态: %@", status);
  } else {
    NSLog(@"[rtnet]状态流未就绪，无法回调状态");
  }
}

// 回调数据消息到 Flutter
- (void)callbackData:(NSData *)data {
  if (self.dataEventChannel) {
    FlutterStandardTypedData *flutterData = [FlutterStandardTypedData typedDataWithBytes:data];
    self.dataEventChannel(flutterData);
    NSLog(@"[rtnet]回调数据: %@", data);
  } else {
    NSLog(@"[rtnet]数据流未就绪，无法回调数据");
  }
}

@end
