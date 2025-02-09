#import "RtnetPlugin.h"
#import "NetworkManager.h"

@interface RtnetPlugin () <NetworkManagerDelegate>
@property(nonatomic, strong) FlutterEventSink eventSink;
@property(nonatomic, strong) NetworkManager *netClient;
@end

@implementation RtnetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  NSLog(@"registerWithRegistrar");
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"rtnet" binaryMessenger:[registrar messenger]];
  FlutterEventChannel *eventChannel =
      [FlutterEventChannel eventChannelWithName:@"rtnet_event"
                                binaryMessenger:[registrar messenger]];
  RtnetPlugin *instance = [[RtnetPlugin alloc] init];
  // 初始化网络
  [instance initNetClient];
  [registrar addMethodCallDelegate:instance channel:channel];
  // 注册流事件的处理
  [eventChannel setStreamHandler:instance];
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
    int ret = [self send:call.arguments[@"data"]];
    result([NSNumber numberWithInt:ret]);
  } else if ([@"close" isEqualToString:call.method]) {
    int ret = [self close];
    result([NSNumber numberWithInt:ret]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
  // 保存事件回调
  NSLog(@"onListenWithArguments");
  self.eventSink = events;
  return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
  NSLog(@"onCancelWithArguments");
  self.eventSink = nil;
  return nil;
}

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

- (int)send:(NSString *)string {
  // 发送数据
  NSLog(@"send: %@", string);
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
  return [self.netClient send:data];
}

- (int)close {
  // 关闭连接
   [self.netClient close];
    return 0;
}

- (void)onOpen {
  // 通知Flutter端连接已经打开
  if (self.eventSink) {
    self.eventSink(@"open");
  }
}

- (void)onReceiveData:(NSData *)data {
  // 通知Flutter端收到数据
  NSLog(@"onReceiveData %@", data);
  if (self.eventSink) {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.eventSink(string);
  }
}

- (void)onError:(NSError *)error {
  // 通知Flutter端发生错误
  if (self.eventSink) {
    self.eventSink(error.localizedDescription);
  }
}

- (int)onLogPrint:(int)prio logMessage:(NSString *)logMessage {
  NSLog(@"[rtnet]: %d, %@", prio, logMessage);
  return 0;
}

@end
