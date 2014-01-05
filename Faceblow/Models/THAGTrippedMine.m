//
// Created by nick on 1/4/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import "THAGTrippedMine.h"


@implementation THAGTrippedMine {

}


@synthesize bombedId = _bombedId;
@synthesize bomberId = _bomberId;
@synthesize explodedAt = _explodedAt;
@synthesize id = _id;
@synthesize location = _location;

/*
2014-01-04 20:33:01.161 Faceblow[23130:70b] {
    bombed = abcdefghijklmnop;
    bomber = abcdefghijklmnop;
    explodedAt = "2014-01-05T01:33:01.131Z";
    id = 52c8b64defc0798059000003;
    lat = "37.33399556924093";
    long = "-122.0488865138117";
}
 */
-(id)initWithDataDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if(self != nil){
        _bombedId = [dataDict objectForKey:@"bombed"];
        _bomberId = [dataDict objectForKey:@"bomber"];
        _id = [dataDict objectForKey:@"id"];
        NSString *dateString = [dataDict objectForKey:@"explodedAt"];
        NSString *latitudeString = [dataDict objectForKey:@"lat"];
        NSString *longitudeString = [dataDict objectForKey:@"long"];

        if(!_bombedId || !_bomberId || !_id || !dateString || !latitudeString || !longitudeString){
            NSException *e = [NSException exceptionWithName:@"Bad Data" reason:@"Invalid Tripped Mine Data Retrieved" userInfo:nil];
            @throw e;
        }

        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:SS.SSS'Z'";
        [formatter setTimeZone:gmt];
        _explodedAt = [formatter dateFromString:dateString];

        CLLocationDegrees lat = [latitudeString doubleValue];
        CLLocationDegrees longi = [longitudeString doubleValue];
        _location = [[CLLocation alloc] initWithLatitude:lat longitude:longi];
    }
    return self;
}

@end