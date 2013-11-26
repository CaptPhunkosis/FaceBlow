//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import "THAGPlantedMineAnnotation.h"


@implementation THAGPlantedMineAnnotation {
    CLLocationCoordinate2D _coordinate;
}

- (CLLocationCoordinate2D)coordinate {
    _coordinate.latitude = [self.latitude doubleValue];
    _coordinate.longitude = [self.longitude doubleValue];
    return _coordinate;
}

@end