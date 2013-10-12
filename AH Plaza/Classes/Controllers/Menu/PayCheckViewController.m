//
//  PayCheckViewController.m
//  AH Plaza Unofficial
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "PayCheckViewController.h"
#import "APIClient.h"

@interface PayCheckViewController ()

@end

@implementation PayCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Retreive the paychecks
    [[APIClient sharedInstance] loadPayCheckPage:^(NSArray *paychecks, NSError * error) {
        NSLog(@"Downloaded everything");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
