//
//  RTClientCallback.cpp
//  rtclient_example
//
//  Created by Jiafeng Chen on 2024/11/9.
//

#import "RTClientCallback.h"
#import <Foundation/Foundation.h>

ClientCallback::ClientCallback(id NetworkManager) : networkManager_(NetworkManager) {}

ClientCallback::~ClientCallback() {}

void ClientCallback::onOpen() {
  NSLog(@"Client opened!");
  if ([networkManager_ respondsToSelector:@selector(onOpen)]) {
    [networkManager_ performSelector:@selector(onOpen)];
  }
}

void ClientCallback::onRecv(char* data, int len) {
  NSData* dataObject = [NSData dataWithBytes:data length:len];
  NSLog(@"onRecv[%lu]:%@", (unsigned long)dataObject.length, dataObject);
  if ([networkManager_ respondsToSelector:@selector(onRecv:)]) {
    [networkManager_ performSelector:@selector(onRecv:) withObject:dataObject];  // 触发回调
  }
}

void ClientCallback::onError(int code, int subcode, char* desc) {
  NSLog(@"onClose code:%d, subcode:%d desc:%s", code, subcode, desc);
  if ([networkManager_ respondsToSelector:@selector(onError:)]) {
    NSError* errInfo = createNSError(code, subcode, desc);
    [networkManager_ performSelector:@selector(onError:) withObject:errInfo];
  }
}

NSError* ClientCallback::createNSError(int code, int subcode, const char* desc) {
  NSString* errorDomain = @"com.reclient.error";                      // 错误域
  NSString* errorDescription = [NSString stringWithUTF8String:desc];  // 错误描述

  // 合并 code 和 subcode，创建完整的错误码
  int fullErrorCode = code * 1000 + subcode;  // 你可以根据实际情况修改这里的合并方式

  // 创建包含描述信息的字典
  NSDictionary* userInfo = @{NSLocalizedDescriptionKey : errorDescription};

  // 创建 NSError 对象
  NSError* error = [NSError errorWithDomain:errorDomain code:fullErrorCode userInfo:userInfo];
  return error;
}
