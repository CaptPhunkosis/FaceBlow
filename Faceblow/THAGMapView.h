//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "THAGPlantedMineAnnotation.h"
#import "THAGMine.h"


@protocol THAGMapViewDelegate <MKMapViewDelegate>
@end



@interface THAGMapView : MKMapView

-(void) updatePlantedMines:(NSArray *) plantedMines;

@end