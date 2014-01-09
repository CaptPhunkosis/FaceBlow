//
// Created by nick on 1/5/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import "THAGUserState.h"


@implementation THAGUserState {

}

@synthesize createdOn = _createdOn;
@synthesize updatedOn = _updatedOn;
@synthesize explodedCount = _explodedCount;
@synthesize explodesCount = _explodesCount;
@synthesize liveMines = _liveMines;
@synthesize uuid = _uuid;
@synthesize plantedMines = _plantedMines;
@synthesize unackedMines = _unackedMines;

-(id)initWithDataDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if(self != nil){

        _plantedMines = [[NSMutableArray alloc] init];
        _unackedMines = [[NSMutableArray alloc] init];

        NSString *createdOnString = [dataDict objectForKey:@"createdOn"];
        NSString *updatedOnString = [dataDict objectForKey:@"updatedOn"];
        _explodedCount = [[dataDict objectForKey:@"exploded"] integerValue];
        _explodesCount = [[dataDict objectForKey:@"explodes"] integerValue];
        _liveMines = [[dataDict objectForKey:@"liveMines"] integerValue];
        _uuid = [dataDict objectForKey:@"uuid"];

        if(!createdOnString || !updatedOnString || !_uuid){
            NSException *e = [NSException exceptionWithName:@"Bad Data" reason:@"Invalid User Info Data Retrieved" userInfo:nil];
            @throw e;
        }

        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:SS.SSS'Z'";
        [formatter setTimeZone:gmt];
        _createdOn = [formatter dateFromString:createdOnString];
        _updatedOn = [formatter dateFromString:updatedOnString];
    }
    return self;
}

@end

/*
user =         {
            createdOn = "2014-01-05T06:20:23.556Z";
            exploded = 0;
            explodes = 0;
            liveMines = 0;
            updatedOn = "2014-01-05T06:20:23.558Z";
            uuid = abcdefghijklmnop;
        };
 */