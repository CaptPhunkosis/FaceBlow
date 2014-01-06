//
// Created by nick on 1/4/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THAGMine.h"

@interface THAGTrippedMine : THAGMine

@property (readonly) NSDate *explodedAt;
@property (readonly) NSString *bombedId;
@property (readonly) NSString *bomberId;


-(id)initWithDataDictionary:(NSDictionary *)dataDict;

@end