//
// Created by nick on 1/4/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import "THAGTrippedMine.h"


@implementation THAGTrippedMine {

}

@synthesize explodedAt = _explodedAt;
@synthesize bombedId = _bombedId;
@synthesize bomberId = _bomberId;


-(id)initWithDataDictionary:(NSDictionary *)dataDict {
    self = [super initWithDataDictionary:dataDict];
    if(self != nil){
        _bombedId = [dataDict objectForKey:@"bombed"];
        _bomberId = [dataDict objectForKey:@"bomber"];
        NSString *dateString = [dataDict objectForKey:@"explodedAt"];

        if(!_bombedId || !_bomberId || !dateString){
            NSException *e = [NSException exceptionWithName:@"Bad Data" reason:@"Invalid Tripped Mine Data Retrieved" userInfo:nil];
            @throw e;
        }

        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:SS.SSS'Z'";
        [formatter setTimeZone:gmt];
        _explodedAt = [formatter dateFromString:dateString];
    }
    return self;
}

@end