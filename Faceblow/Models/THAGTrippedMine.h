//
// Created by nick on 1/4/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface THAGTrippedMine : NSObject

@property NSString *bombedId;
@property NSString *bomberId;
@property NSDate *explodedAt;
@property NSString *id;
@property CLLocation *location;


-(id)initWithDataDictionary:(NSDictionary *)dataDict;
@end