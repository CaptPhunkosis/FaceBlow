//
// Created by nick on 11/24/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//


#import "THAGApiHandler.h"


static NSString * const APIENDPOINT = @"http://localhost:3000";

@implementation THAGApiHandler {

    AFHTTPRequestOperationManager *manager;
}

@synthesize uuid = _uuid;
@synthesize delegate = _delegate;

- (id)initWithUUID:(NSString *)uuid{
    if(self = [super init]){
        _uuid = uuid;
        manager = [AFHTTPRequestOperationManager manager];
    }

    return self;
}


- (void)fetchUserState {
    NSString *endPoint = [NSString stringWithFormat:@"%@/user/%@", APIENDPOINT, self.uuid];
    [manager GET:endPoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        if([responseObject isKindOfClass:[NSDictionary class]]){
            if(self.delegate != nil){
                [self.delegate fetchUserStateComplete:(NSDictionary *)responseObject];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"FETCH USER ERROR %@", error);
    }];
}

- (void)checkForMines:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    NSString *endPoint = [NSString stringWithFormat:@"%@/user/%@/checkformines", APIENDPOINT, self.uuid];
    NSArray *keys = [NSArray arrayWithObjects:@"latitude", @"longitude", nil];
    NSArray *objects = [NSArray arrayWithObjects:latitude, longitude, nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [manager GET:endPoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        if(self.delegate != nil){
            [self.delegate checkForMinesComplete:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"CHECK FOR MINE ERROR %@", error);
    }];
}

- (void)placeNewMine:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    NSString *endPoint = [NSString stringWithFormat:@"%@/user/%@/plantmine", APIENDPOINT, self.uuid];
    NSArray *keys = [NSArray arrayWithObjects:@"latitude", @"longitude", nil];
    NSArray *objects = [NSArray arrayWithObjects:latitude, longitude, nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];

    [manager POST:endPoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        if(self.delegate != nil){
            [self.delegate placeNewMineComplete:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"PLACE MINE ERROR %@", error);
    }];
}


@end