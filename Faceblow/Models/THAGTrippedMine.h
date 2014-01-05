//
// Created by nick on 1/4/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THAGMine.h"

@interface THAGTrippedMine : THAGMine

@property NSDate *explodedAt;
@property NSString *bombedId;
@property NSString *bomberId;


-(id)initWithDataDictionary:(NSDictionary *)dataDict;

@end