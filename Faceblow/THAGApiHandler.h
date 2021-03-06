//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "THAGUserState.h"
#import "THAGMine.h"
#import "THAGTrippedMine.h"

@protocol THAGApiHandlerDelegate <NSObject>
@required
- (void) fetchUserStateComplete:(THAGUserState *)results;
- (void) checkForMinesComplete:(NSDictionary *)results;
- (void) placeNewMineComplete:(NSDictionary *)results;
- (void) tripMineComplete:(THAGTrippedMine *)results;
- (void) acknowledgeTrippedMineComplete:(THAGTrippedMine *)results;
@end



@interface THAGApiHandler : NSObject

@property (nonatomic, readonly) NSString *uuid;
@property (nonatomic, weak) id delegate;

- (id) initWithUUID:(NSString *)uuid;
- (void)fetchUserState;
- (void)checkForMines:(NSNumber *)latitude longitude:(NSNumber *)longitude;
- (void)placeNewMine:(NSNumber *)latitude longitude:(NSNumber *)longitude;
- (void)tripMine:(NSString *)mineID;
- (void)acknowledgeTrippedMine:(NSString *)mineID;

@end
