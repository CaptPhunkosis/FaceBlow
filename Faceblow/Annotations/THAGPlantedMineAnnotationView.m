//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import "THAGPlantedMineAnnotationView.h"


@implementation THAGPlantedMineAnnotationView {
}
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pinColor = MKPinAnnotationColorGreen;
    }

    return self;
}

@end