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
        THAGUserState *userState = nil;

        if(responseObject && [responseObject objectForKey:@"data"]){
            NSDictionary *data = [responseObject valueForKey:@"data"];
            if([data isKindOfClass:[NSDictionary class]] && [data objectForKey:@"user"]){
                userState = [[THAGUserState alloc] initWithDataDictionary:[data objectForKey:@"user"]];

                for(NSDictionary *plantedMine in [data objectForKey:@"plantedMines"]){
                    THAGMine *newMine = [[THAGMine alloc] initWithDataDictionary:plantedMine];
                    [userState.plantedMines addObject:newMine];
                }
            }
        }

        if(self.delegate != nil){
            [self.delegate fetchUserStateComplete:userState];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"FETCH USER ERROR %@", error);
    }];
}


- (void)checkForMines:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    NSString *endPoint = [NSString stringWithFormat:@"%@/user/%@/checkformines", APIENDPOINT, self.uuid];
    NSDictionary *params = @{@"latitude": latitude, @"longitude": longitude};

    [manager GET:endPoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSMutableArray *userMines = [[NSMutableArray alloc] init];
        NSMutableArray *otherMines = [[NSMutableArray alloc] init];

        if(responseObject && [responseObject objectForKey:@"data"]){
            NSDictionary *data = [responseObject objectForKey:@"data"];

            if([data objectForKey:@"users"]){
                for(NSDictionary *userMine in [data objectForKey:@"users"]){
                    THAGMine *newMine = [[THAGMine alloc] initWithDataDictionary:userMine];
                    [userMines addObject:newMine];
                }
            }

            if([data objectForKey:@"others"]){
                for(NSDictionary *otherMine in [data objectForKey:@"others"]){
                    THAGMine *newMine = [[THAGMine alloc] initWithDataDictionary:otherMine];
                    [otherMines addObject:newMine];
                }
            }

        }

        NSDictionary *results = @{@"userMines": userMines, @"otherMines": otherMines};

        if(self.delegate != nil){
            [self.delegate checkForMinesComplete:results];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"CHECK FOR MINE ERROR %@", error);
    }];
}


- (void)placeNewMine:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    NSString *endPoint = [NSString stringWithFormat:@"%@/user/%@/plantmine", APIENDPOINT, self.uuid];
    NSDictionary *params = @{@"latitude": latitude, @"longitude": longitude};

    [manager POST:endPoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        if(self.delegate != nil){
            [self.delegate placeNewMineComplete:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"PLACE MINE ERROR %@", error);
    }];
}


- (void)tripMine:(NSString *)mineID {
    NSString *endPoint = [NSString stringWithFormat:@"%@/user/%@/tripMine", APIENDPOINT, self.uuid];
    NSDictionary *params = @{@"mineID": mineID};

    [manager POST:endPoint parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        THAGTrippedMine *trippedMine = nil;

        if(responseObject && [responseObject objectForKey:@"data"]) {
            trippedMine = [[THAGTrippedMine alloc] initWithDataDictionary:[responseObject objectForKey:@"data"]];
        }

        if(self.delegate != nil){
            [self.delegate tripMineComplete:trippedMine];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"TRIP MINE ERROR %@", error);
    }];
}

@end