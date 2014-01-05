//
// Created by nick on 1/5/14.
// Copyright (c) 2014 Thag Industries. All rights reserved.
//

#import "THAGMine.h"


@implementation THAGMine {

}


@synthesize id = _id;
@synthesize location = _location;
@synthesize createdOn = _createdOn;


-(id)initWithDataDictionary:(NSDictionary *)dataDict {
    self = [super init];
    if(self != nil){
        _id = [dataDict objectForKey:@"id"];
        NSString *latitudeString = [dataDict objectForKey:@"lat"];
        NSString *longitudeString = [dataDict objectForKey:@"long"];
        NSString *dateString = [dataDict objectForKey:@"createdOn"];

        if(!_id || !latitudeString || !longitudeString || !dateString){
            NSException *e = [NSException exceptionWithName:@"Bad Data" reason:@"Invalid Mine Data Retrieved" userInfo:nil];
            @throw e;
        }

        CLLocationDegrees lat = [latitudeString doubleValue];
        CLLocationDegrees longi = [longitudeString doubleValue];
        _location = [[CLLocation alloc] initWithLatitude:lat longitude:longi];

        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:SS.SSS'Z'";
        [formatter setTimeZone:gmt];
        _createdOn = [formatter dateFromString:dateString];

    }
    return self;
}
@end