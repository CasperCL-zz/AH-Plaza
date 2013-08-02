//
//  SettingsViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 22-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
//    [_keepLoggedInSwitch setLeftLabelText: @"Ja"];
//    [_keepLoggedInSwitch setRightLabelText: @"Nee"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setKeepLoggedInSwitch:nil];
    [super viewDidUnload];
}
@end
