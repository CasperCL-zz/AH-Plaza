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
    
    
    if([[_dataObject workingTimes] count]) {
        [_weekLabel setText: [_dataObject weekID]];
        
        NSString* from = [[[_dataObject workingTimes] objectForKey: @"monday"] objectForKey:@"from"];
        NSString* till = [[[_dataObject workingTimes] objectForKey: @"monday"] objectForKey:@"till"];
        [_mondayFromLabel setText: from];
        [_mondayTillLabel setText: till];
        [_mondayTotalLabel setText: [self calculateTotalFrom: from till: till]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"tuesday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"tuesday"] objectForKey:@"till"];
        [_tuesdayFromLabel setText: from];
        [_tuesdayTillLabel setText: till];
        [_tuesdayTotalLabel setText: [self calculateTotalFrom: from till: till]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"wednesday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"wednesday"] objectForKey:@"till"];
        [_wedsdayFromLabel setText: from];
        [_wedsdayTillLabel setText: till];
        [_wedsdayTotalLabel setText: [self calculateTotalFrom: from till: till]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"thursday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"thursday"] objectForKey:@"till"];
        [_thursdayFromLabel setText: from];
        [_thursdayTillLabel setText: till];
        [_thursdayTotalLabel setText: [self calculateTotalFrom: from till: till]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"friday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"friday"] objectForKey:@"till"];
        [_fridayFromLabel setText: from];
        [_fridayTillLabel setText: till];
        [_fridayTotalLabel setText: [self calculateTotalFrom: from till: till]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"saturday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"saturday"] objectForKey:@"till"];
        [_saturdayFromLabel setText: from];
        [_saturdayTillLabel setText: till];
        [_saturdayTotalLabel setText: [self calculateTotalFrom: from till: till]];
        
        from = [[[_dataObject workingTimes] objectForKey: @"sunday"] objectForKey:@"from"];
        till = [[[_dataObject workingTimes] objectForKey: @"sunday"] objectForKey:@"till"];
        [_sundayFromLabel setText: from];
        [_sundayTillLabel setText: till];
        [_sundayTotalLabel setText: [self calculateTotalFrom: from till: till]];
        
        NSString *totalHoursWorkedS = [self timeDoubleToString: totalHoursWorked];
        [_overallTotal setText: totalHoursWorkedS];
        
    } else {
        // Show error
    }
}

-(NSString*) calculateTotalFrom: (NSString*)from till: (NSString*) till {

    if([from isEqualToString:@"-"])
        return @"00:00";
    
    double difference;
    double doubleFormatFrom = [self timeStringToDouble: from];
    double doubleFormatTill = [self timeStringToDouble: till];
    // Calculate the difference between the times (included nights e.g. from 23:00 till 05:00)
    if(doubleFormatTill > doubleFormatFrom)
        difference = doubleFormatTill - doubleFormatFrom;
    else
        difference = abs((doubleFormatFrom - 24)) + doubleFormatTill;

    
    
    totalHoursWorked += difference;
    return [self timeDoubleToString: difference];
}

-(double) timeStringToDouble: (NSString*) timeString {
    double timeDouble = 0.0;
    
    int n1 = [timeString characterAtIndex:0] - '0';
    int n2 = [timeString characterAtIndex:1] - '0';
    // Skip the ':' char (index 2)
    int n3 = [timeString characterAtIndex:3] - '0';
    int n4 = [timeString characterAtIndex:4] - '0';
    
    timeDouble = (n1*10) + n2 + ( (double)((n3*10) + (n4)) / 60);
    
    return timeDouble;
}

- (NSString*) timeDoubleToString: (double) timeDouble {
    NSString *hours;
    if(floor(timeDouble) < 10)
        hours = [[NSString alloc] initWithFormat:@"0%i", (int)floor(timeDouble)];
    else
        hours = [[NSString alloc] initWithFormat:@"%i", (int)floor(timeDouble)];
    NSString *minutes;
    if((int)((timeDouble - floor(timeDouble))* 60))
        minutes = [[NSString alloc] initWithFormat:@"%i", (int)((timeDouble - floor(timeDouble))* 60)];
    else
        minutes = @"00";
    
    return [[NSString alloc] initWithFormat:@"%@:%@", hours, minutes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWeekLabel:nil];
    [self setMondayFromLabel:nil];
    [self setMondayTillLabel:nil];
    [self setMondayTotalLabel:nil];
    [self setTuesdayFromLabel:nil];
    [self setOverallTotal:nil];
    [super viewDidUnload];
}
@end
