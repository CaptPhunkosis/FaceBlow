//
// Created by nick on 1/5/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface THAGMine : NSObject

@property (readonly) NSString *id;
@property (readonly) CLLocation *location;
@property (readonly) NSDate *createdOn;

-(id)initWithDataDictionary:(NSDictionary *)dataDict;

@end