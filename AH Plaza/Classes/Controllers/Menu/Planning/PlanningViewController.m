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
#import "SettingsManager.h"
#import "Constants.h"

@interface PlanningViewController ()

@end

@implementation PlanningViewController

double totalHoursWorked;

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
    totalHoursWorked = 0;
    UIColor * bgColor = UIColorFromRGB(ah_blue);
    [_backgroundView setBackgroundColor: bgColor];
    [_weekLabel setTextColor: bgColor];
    _backgroundView.layer.cornerRadius = 5;
    _backgroundView.layer.masksToBounds = YES;
    
    
    for(UILabel * label in _staticLabels){
        [label setTextColor: bgColor];
    }
    
    if(![[SettingsManager sharedInstance] planningInstructionsDisplayed]) {
        _instructionDialogBackground.alpha = 0.7f;
        _instructionDialogView.alpha = 1.0f;
        _instructionDialogView.hidden = NO;
        _instructionDialogBackground.hidden = NO;
        
        _instructionDialogView.layer.cornerRadius = 10.0;
        _instructionDialogView.layer.masksToBounds = YES;
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideInstructions) userInfo:nil repeats:NO];
        [[SettingsManager sharedInstance] setPlanningInstructionsDisplayed: YES];
    }
    
    if([[_dataObject workingTimes] count]) {
        [_dataObject setWeekID: [[_dataObject weekID] capitalizedString]];
        [_weekLabel setText: [_dataObject weekID]];
        
        NSString* from = [[[_dataObject workingTimes] objectForKey: @"monday"] objectForKey:@"from"];
        NSString* till = [[[_dataObject workingTimes] objectForKey: @"monday"] objectForKey:@"till"];
        [_mondayFromLabel setText: from];
        [_mondayTillLabel setText: till];
        [_mondayTotalLabel setText: [[[_dataObject workingTimes] objectForKey: @"monday"] objectForKey:@"total"]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"tuesday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"tuesday"] objectForKey:@"till"];
        [_tuesdayFromLabel setText: from];
        [_tuesdayTillLabel setText: till];
        [_tuesdayTotalLabel setText: [[[_dataObject workingTimes] objectForKey: @"tuesday"] objectForKey:@"total"]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"wednesday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"wednesday"] objectForKey:@"till"];
        [_wedsdayFromLabel setText: from];
        [_wedsdayTillLabel setText: till];
        [_wedsdayTotalLabel setText: [[[_dataObject workingTimes] objectForKey: @"wednesday"] objectForKey:@"total"]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"thursday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"thursday"] objectForKey:@"till"];
        [_thursdayFromLabel setText: from];
        [_thursdayTillLabel setText: till];
        [_thursdayTotalLabel setText: [[[_dataObject workingTimes] objectForKey: @"thursday"] objectForKey:@"total"]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"friday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"friday"] objectForKey:@"till"];
        [_fridayFromLabel setText: from];
        [_fridayTillLabel setText: till];
        [_fridayTotalLabel setText: [[[_dataObject workingTimes] objectForKey: @"friday"] objectForKey:@"total"]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"saturday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"saturday"] objectForKey:@"till"];
        [_saturdayFromLabel setText: from];
        [_saturdayTillLabel setText: till];
        [_saturdayTotalLabel setText: [[[_dataObject workingTimes] objectForKey: @"saturday"] objectForKey:@"total"]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"sunday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"sunday"] objectForKey:@"till"];
        [_sundayFromLabel setText: from];
        [_sundayTillLabel setText: till];
        [_sundayTotalLabel setText:[[[_dataObject workingTimes] objectForKey: @"sunday"] objectForKey:@"total"]];
        
        [_overallTotal setText: [_dataObject totalHours]];
        
    } else {
        // Show error
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideInstructions {
    [UIView animateWithDuration: 2.0 animations:^{
        _instructionDialogBackground.alpha = 0.0f;
        _instructionDialogView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _instructionDialogBackground.hidden = YES;
        _instructionDialogView.hidden = YES;
    }];
}


- (void)viewDidUnload {
    [self setWeekLabel:nil];
    [self setMondayFromLabel:nil];
    [self setMondayTillLabel:nil];
    [self setMondayTotalLabel:nil];
    [self setTuesdayFromLabel:nil];
    [self setOverallTotal:nil];
    [self setInstructionDialogBackground:nil];
    [self setInstructionDialogView:nil];
    [super viewDidUnload];
}
@end
