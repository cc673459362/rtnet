//
//  netWorkCallbackBridge.cpp
//  rtclient_example
//
//  Created by Jiafeng Chen on 2024/11/9.
//

#import "NetworkManager.h"
#import "RTClient/RTClient.h"
#import "RTClient/RTNet.h"
#import "RTClientCallback.h"

NetworkManager *globalNetManager = nil;

@interface NetworkManager ()

@property(nonatomic, assign) std::shared_ptr<ClientCallback> callback;
@property(nonatomic, assign) std::shared_ptr<RTClient::RTClient> client_c;

@end

@implementation NetworkManager

- (instancetype)initNetworkManagerWithDelegate:(id<NetworkManagerDelegate>)delegate {
  self = [super init];
  if (self) {
    NSLog(@"NetworkManager init");
    globalNetManager = self;
    // 创建 C++ 回调对象
    self.delegate = delegate;
    self.callback = std::make_shared<ClientCallback>(self);
    RTClient::init(myLogCallback);
    self.client_c = RTClient::CreateRTClient();
  }

  return self;
}

- (void)open:(NSString *)ip port:(NSString *)port {
  if (self && self.client_c) {
    NSLog(@"Open connection to %@:%@", ip, port);
    const char *ip_c = [ip UTF8String];
    int port_n = [port intValue];
    self.client_c->Open(ip_c, port_n, self.callback);
  }
}

- (int)send:(NSData *)data {
  if (self && self.client_c) {
    NSLog(@"Send data: %@", data);
    const char *bytes = (const char *)[data bytes];
    int length = (int)[data length];
    return self.client_c->Send(bytes, length);
  }
  return -1;
}

- (void)close {
  if (self && self.client_c) {
    NSLog(@"Close connection");
    self.client_c->Close();
  }
}

- (void)onOpen {
  NSLog(@"Connection opened!");
  if (self.delegate) {
    [self.delegate onOpen];
  }
}

- (void)onRecv:(NSData *)data {
  NSLog(@"Received data: %@", data);
  if (self.delegate) {
    [self.delegate onReceiveData:data];
  }
}

- (void)onError:(NSError *)error {
  // 从 error 中提取 code
  NSNumber *code = @(error.code);

  // 从 userInfo 字典中提取 subcode 和 description
  NSNumber *subcode = error.userInfo[@"subcode"];
  NSString *desc = error.userInfo[NSLocalizedDescriptionKey];

  NSLog(@"Encountered error: code=%@, subcode=%@, description=%@", code, subcode, desc);

  if (self.delegate) {
    [self.delegate onError:error];
  }
}

// 打印rtclient日志
- (int)onLog:(int)prio logMessage:(NSString *)logMessage {
  if (self.delegate && [self.delegate respondsToSelector:@selector(onLogPrint:logMessage:)]) {
    return [self.delegate onLogPrint:prio logMessage:logMessage];
  }
  return 0;  // 或返回您需要的值
}

int myLogCallback(int prio, const char *text) {
  NSString *nsString = @"";
  if (text != NULL) {
    nsString = [NSString stringWithUTF8String:text];
  } else {
    NSLog(@"text is NULL");
  }
  if (globalNetManager) {
    return [globalNetManager onLog:prio logMessage:nsString];
  }
  return -1;  // 如果没有对象，则返回一个默认值
}

@end
