//
//  PlanningViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 23-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "PlanningViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WebHelper.h"

@interface PlanningViewController ()

@end

@implementation PlanningViewController

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
    _roosterView.layer.borderColor = [UIColor blueColor].CGColor;
    _roosterView.layer.borderWidth = 1.0f;
    
    [[WebHelper sharedInstance] loadTimetablePage:^(NSArray *weeks) {
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRoosterView:nil];
    [self setWeekLabel:nil];
    [super viewDidUnload];
}
@end
