//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "THAGMapView.h"
#import "THAGApiHandler.h"
#import "THAGPlantedMineAnnotationView.h"
#import "THAGUserState.h"
#import "THAGMine.h"
#import "THAGTrippedMine.h"
#import "THAGTrippeMineViewController.h"

@interface THAGMainViewController : UIViewController <CLLocationManagerDelegate, THAGMapViewDelegate, THAGApiHandlerDelegate>

- (void)acknowledgeTrippedMine:(THAGTrippedMine *)trippedMine;

@end