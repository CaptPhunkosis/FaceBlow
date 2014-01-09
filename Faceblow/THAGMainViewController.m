//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "THAGMainViewController.h"


static NSString * const TESTDEVICEUID = @"abcdefghijklmnop";
static NSTimeInterval const MINUSERUPDATEINTERVAL = 3.0f;

@implementation THAGMainViewController {
    CLLocationManager *_locationManager;
    THAGMapView *_mapView;
    THAGApiHandler *_apiHandler;

    NSMutableArray *_unackedMines;

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
    _unackedMines = [[NSMutableArray alloc] init];


    //Setup location handling.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];


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


- (void)checkUnackedMines {
    if(_unackedMines && _unackedMines.count > 0){
        [self presentTrippedMineViewController:[_unackedMines objectAtIndex:0]];
    }
}

-(void)presentTrippedMineViewController:(THAGTrippedMine *)trippedMine {
    THAGTrippeMineViewController *trippedVC = [[THAGTrippeMineViewController alloc] initWithMine:trippedMine];
    [trippedVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:trippedVC animated:YES completion:nil];
}



#pragma mark - Location Services
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0, 0.0}};
    region.center = newLocation.coordinate;
    region.span.latitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [_mapView setRegion:region animated:YES];

    if(_lastMineCheck == nil || [[NSDate date] timeIntervalSinceDate:_lastMineCheck] >= MINUSERUPDATEINTERVAL) {
        _lastMineCheck = [NSDate date];
        [_apiHandler checkForMines:[NSNumber numberWithDouble:newLocation.coordinate.latitude] longitude:[NSNumber numberWithDouble:newLocation.coordinate.longitude]];
    }
}







#pragma mark - Map View

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



#pragma mark - Data Methods

- (void)acknowledgeTrippedMine:(THAGTrippedMine *)trippedMine {
    [_apiHandler acknowledgeTrippedMine:trippedMine.id];
}

- (void)acknowledgeTrippedMineComplete:(THAGTrippedMine *)trippedMine {
    THAGTrippedMine *mineToRemove;
    for(THAGTrippedMine *unackedMine in _unackedMines){
        if([unackedMine.id isEqualToString:trippedMine.id]){
            mineToRemove = unackedMine;
        }
    }

    if(mineToRemove){
        [_unackedMines removeObject:mineToRemove];
    }

    if(_unackedMines.count > 0){
        [self checkUnackedMines];
    } else {
        [_apiHandler fetchUserState];
    }
}


- (void)fetchUserStateComplete:(THAGUserState *)userState {
    if(userState){
        [_mapView updatePlantedMines:userState.plantedMines];
        _unackedMines = [userState.unackedMines mutableCopy];
        [self checkUnackedMines];
    }
}


- (void)checkForMinesComplete:(NSDictionary *)results {
    if(results){
        NSArray *userMines = [results objectForKey:@"userMines"];
        NSArray *otherMines = [results objectForKey:@"otherMines"];
        _userCanLayMine = [userMines count] <= 0 && [otherMines count] <= 0;

        if(otherMines.count > 0){
            THAGMine *mineToTrip = [otherMines objectAtIndex:0];
            [_apiHandler tripMine:mineToTrip.id];
        }
    }
}

- (void)placeNewMineComplete:(NSDictionary *)results {
    [_apiHandler fetchUserState];
}


- (void)tripMineComplete:(THAGTrippedMine *)trippedMine {
    if(trippedMine){

        BOOL _isBackground = [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
        if(_isBackground){
            UILocalNotification *notification = [[UILocalNotification alloc]  init];
            notification.alertBody = [NSString stringWithFormat:@"BOOM.  %@ just blew your face off.", trippedMine.bomberId];
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

        } else {
            [self presentTrippedMineViewController:trippedMine];
        }
    }
}


@end