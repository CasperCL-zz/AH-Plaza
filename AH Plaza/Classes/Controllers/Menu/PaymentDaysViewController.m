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

@property NSMutableArray * tableText;

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
    _tableText = [[NSMutableArray alloc] init];
    
    
    _upcommingPaymentView.layer.cornerRadius = 10;
    _upcommingPaymentView.layer.masksToBounds = YES;
    
    
    
    NSDate * originalDate;
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    
    // Create file manager
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *fileLocation = [[NSString alloc] initWithFormat: @"%@/%@", documentsDirectory , @"date.ahpu"];
    
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    if(![[NSFileManager defaultManager] fileExistsAtPath: fileLocation]) {
        [dateComponents setHour: 14];
        [dateComponents setDay: 22];
        [dateComponents setMonth: 7];
        [dateComponents setYear: 2013];
        NSDate *dateToWrite = [cal dateFromComponents:dateComponents];
        [NSKeyedArchiver archiveRootObject: dateToWrite toFile: fileLocation];
        NSLog(@"Wrote: %@", dateToWrite);
        originalDate = dateToWrite;
    } else  {
        NSDate *savedDate = [NSKeyedUnarchiver unarchiveObjectWithFile: fileLocation];
        NSLog(@"Read: %@", savedDate);
        originalDate = savedDate;
    }
    
    // Check if outdated
    NSDate * now = [[NSDate alloc] init];
    BOOL outdated = [originalDate compare: now] == NSOrderedAscending;
    if(outdated){ // if outdated go to new date
        while ([originalDate compare: now] == NSOrderedAscending) {
            NSLog(@"date is outdated");
            dateComponents = [[NSDateComponents alloc]init];
            [dateComponents setDay: 28];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            originalDate = [calendar dateByAddingComponents: dateComponents toDate: originalDate options:0];
        }
        // Write away the correct date for the next time
        [NSKeyedArchiver archiveRootObject: originalDate toFile: fileLocation];
    }
    
    
    
    // Generate the upcomming 9 months
    for (int i = 0; i < 9; i++) {
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMMM"];
        NSString *newDateS = [df stringFromDate: originalDate];
        
        if(i != 0)
            [_tableText addObject: newDateS];
        else
            [_nextPaymentLabel setText: newDateS];
        
        dateComponents = [[NSDateComponents alloc]init];
        [dateComponents setDay: 28];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* newDate = [calendar dateByAddingComponents: dateComponents toDate: originalDate options:0];
        
        originalDate = newDate;
        

        NSLog(@"New Date: %@", newDateS);
    }
    [_upcommingPaymentsDaysTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUpcommingPaymentView:nil];
    [self setUpcommingPaymentsDaysTable:nil];
    [self setNextPaymentLabel:nil];
    [super viewDidUnload];
}



#pragma UITableView delegates
-(void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableText count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor blackColor]];
    cell.textLabel.text = [_tableText objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size: 17];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}


@end
