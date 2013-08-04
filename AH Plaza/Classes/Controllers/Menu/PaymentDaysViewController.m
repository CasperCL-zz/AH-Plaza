//
//  PaymentDaysViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 02-08-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "PaymentDaysViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PaymentDaysViewController ()

@end

@implementation PaymentDaysViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    _upcommingPaymentView.layer.cornerRadius = 10;
    _upcommingPaymentView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUpcommingPaymentView:nil];
    [self setUpcommingPaymentsDaysTable:nil];
    [super viewDidUnload];
}
@end
