//
// Created by nick on 1/5/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface THAGUserState : NSObject

@property NSDate *createdOn;
@property NSDate *updatedOn;
@property int explodedCount;
@property int explodesCount;
@property int liveMines;
@property NSString *uuid;
@property NSMutableArray *plantedMines;

-(id)initWithDataDictionary:(NSDictionary *)dataDict;

@end