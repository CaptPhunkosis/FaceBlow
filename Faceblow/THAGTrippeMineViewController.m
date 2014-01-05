//
// Created by nick on 12/31/13.
// Copyright (c) 2013 Thag Industries. All rights reserved.
//

#import "THAGTrippeMineViewController.h"


@implementation THAGTrippeMineViewController {
    THAGTrippedMine *_trippedMine;
}

- (id)initWithMine:(THAGTrippedMine *)mine {
    self = [super init];
    if(self != nil){
        _trippedMine = mine;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];

    UILabel *boomLabel = [[UILabel alloc] init];
    boomLabel.numberOfLines = 5;
    boomLabel.text = [NSString stringWithFormat:@"BOOM.\nMine Tripped at\n Lat %f\n Long %f\n planted by %@", _trippedMine.location.coordinate.latitude, _trippedMine.location.coordinate.longitude, _trippedMine.bomberId];
    boomLabel.textAlignment = NSTextAlignmentCenter;
    boomLabel.frame = self.view.bounds;

    UIButton *dismissButton = [[UIButton alloc] init];
    [dismissButton setTitle:@"Ok, got it." forState:UIControlStateNormal];
    dismissButton.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height - 50.0f, self.view.bounds.size.width, 50.0f);
    dismissButton.backgroundColor = [UIColor darkGrayColor];
    [dismissButton addTarget:self action:@selector(dismissTapped) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:dismissButton];
    [self.view addSubview:boomLabel];
}

- (void)dismissTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end