//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface THAGPlantedMineAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end