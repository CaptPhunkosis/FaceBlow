//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import "THAGMapView.h"


@implementation THAGMapView {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mapType = MKMapTypeStandard;
        self.showsPointsOfInterest = NO;
        self.showsUserLocation = YES;
        self.scrollEnabled = NO;
        self.pitchEnabled = NO;
        self.rotateEnabled = NO;
        self.zoomEnabled = NO;
    }

    return self;
}


- (void)updatePlantedMines:(NSArray *)plantedMines {
    if(plantedMines != nil){
        for(NSDictionary *plantedMine in plantedMines){
            NSNumber *longitude = [plantedMine valueForKey:@"long"];
            NSNumber *latitude = [plantedMine valueForKey:@"lat"];

            THAGPlantedMineAnnotation *newPoint = [[THAGPlantedMineAnnotation alloc] init];
            newPoint.latitude = latitude;
            newPoint.longitude = longitude;

            [self addAnnotation:newPoint];
        }
    }
}

@end