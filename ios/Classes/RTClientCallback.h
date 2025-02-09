//
//  RTClientCallback.hpp
//  rtclient_example
//
//  Created by Jiafeng Chen on 2024/11/9.
//

#ifndef RTClientCallback_hpp
#define RTClientCallback_hpp

#import <RTClient/RTClient.h>
#import "NetworkManager.h"

class ClientCallback : public RTClient::RTClientCallback {
 public:
  ClientCallback(id NetworkManager);
  ~ClientCallback();

  void onOpen();
  void onRecv(char* data, int len);
  void onError(int code, int subcode, char* desc);

 private:
  NSError* createNSError(int code, int subcode, const char* desc);

 private:
  id networkManager_;
};

#endif /* RTClientCallback_hpp */
