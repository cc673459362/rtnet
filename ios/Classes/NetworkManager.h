//
//  NETWORKMANAGER_H
//  rtclient_example
//
//  Created by Jiafeng Chen on 2024/11/9.
//

#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H
#import <Foundation/Foundation.h>

@protocol NetworkManagerDelegate <NSObject>

- (void)onOpen;
- (void)onReceiveData:(NSData *)data;
- (void)onError:(NSError *)error;

@optional
- (int)onLogPrint:(int)prio logMessage:(NSString *)logMessage;
@end

@interface NetworkManager : NSObject

@property(nonatomic, weak) id<NetworkManagerDelegate> delegate;

- (instancetype)initNetworkManagerWithDelegate:(id<NetworkManagerDelegate>)delegate;
- (void)open:(NSString *)ip port:(NSString *)port;
- (int)send:(NSData *)data;
- (void)close;

- (void)onOpen;
- (void)onRecv:(NSData *)data;
- (void)onError:(NSError *)error;

@end
#endif /* NETWORKMANAGER_H */
