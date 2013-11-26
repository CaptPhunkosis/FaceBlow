//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import <MapKit/MapKit.h>
#import "THAGMainViewController.h"


static NSString * const TESTDEVICEUID = @"abcdefghijklmnop";
static NSTimeInterval const MINUSERUPDATEINTERVAL = 3.0f;

@implementation THAGMainViewController {
    THAGMapView *_mapView;
    THAGApiHandler *_apiHandler;

    NSDate *_lastMineCheck;
    bool _userCanLayMine;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];

    //SETUP DEFAULTS
    NSString *deviceUUID = TESTDEVICEUID;
    //NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    _userCanLayMine = NO;

    //SETUP MAP
    if(!_mapView){
        _mapView = [[THAGMapView alloc] initWithFrame:self.view.bounds];
    }
    _mapView.delegate = self;
    [self.view addSubview:_mapView];


    //KICK OFF API CALLS
    _apiHandler = [[THAGApiHandler alloc] initWithUUID:deviceUUID];
    _apiHandler.delegate = self;
    [_apiHandler fetchUserState];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - Map View

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //Diable callout
    //userLocation.title = @"";

    MKCoordinateRegion region = {{0.0, 0.0}, {0.0, 0.0}};
    region.center = userLocation.location.coordinate;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [_mapView setRegion:region animated:YES];

    if(_lastMineCheck == nil || [[NSDate date] timeIntervalSinceDate:_lastMineCheck] >= MINUSERUPDATEINTERVAL) {
        _lastMineCheck = [NSDate date];
        [_apiHandler checkForMines:[NSNumber numberWithDouble:userLocation.location.coordinate.latitude] longitude:[NSNumber numberWithDouble:userLocation.location.coordinate.longitude]];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([view.annotation isKindOfClass:[MKUserLocation class]] && _userCanLayMine){
        _userCanLayMine = NO;
        [_apiHandler placeNewMine:[NSNumber numberWithDouble:view.annotation.coordinate.latitude] longitude:[NSNumber numberWithDouble:view.annotation.coordinate.longitude]];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    if([annotation isKindOfClass:[THAGPlantedMineAnnotation class]]){
        static NSString *PlantedMineAnnotationIdentifier = @"plantedMineAnnotationIdentifier";
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:PlantedMineAnnotationIdentifier];
        if(annotationView == nil){
            annotationView = [[THAGPlantedMineAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PlantedMineAnnotationIdentifier];
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }

    return nil;
}



#pragma mark - Data

- (void)fetchUserStateComplete:(NSDictionary *)results {
    if(results && [results valueForKey:@"data"] != nil){
        NSDictionary *data = [results valueForKey:@"data"];
        [_mapView updatePlantedMines:[data valueForKey:@"plantedMines"]];
    }
}


- (void)checkForMinesComplete:(NSDictionary *)results {
    if(results && [results valueForKey:@"data"] != nil){
        NSDictionary *data = [results valueForKey:@"data"];
        NSArray *userMines = [data objectForKey:@"users"];
        _userCanLayMine = [userMines count] <= 0;
    }
}

- (void)placeNewMineComplete:(NSDictionary *)results {
    NSLog(@"MIE PLACE %@", results);
    [_apiHandler fetchUserState];
}


@end