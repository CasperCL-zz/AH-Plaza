//
//  PayCheckViewController.m
//  AH Plaza Unofficial
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "PayCheckViewController.h"
#import "APIClient.h"
#import "PaycheckCell.h"
#import "Paycheck.h"
#import "Fonts.h"

@interface PayCheckViewController ()

@end

@implementation PayCheckViewController

static NSArray * paychecks;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Retreive the paychecks
    if(!paychecks)
        [[APIClient sharedInstance] loadPayCheckPage:^(NSArray *paychecksArray, NSError * error) {
            if([paychecksArray count] > 0 && !error){
                NSLog(@"Downloaded everything (%i paychecks)", [paychecks count]);
                paychecks = paychecksArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            } else {
                // show errors
            }
        }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaycheckCell * paycheckCell = [tableView dequeueReusableCellWithIdentifier:@"PaycheckCell" forIndexPath: indexPath];
    Paycheck * paycheck = [[paychecks objectAtIndex: [indexPath section]] objectAtIndex: [indexPath item]];
    
    [[paycheckCell natureImageView] setImage: [UIImage imageNamed: [[NSString alloc] initWithFormat: @"month-%i", [paycheck month]]]];
    
    [[paycheckCell periodLabel] setText: [paycheck month] ? [[NSString alloc] initWithFormat: @"Periode: %i", [paycheck month]] : @"Jaaropgaaf"];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    [[paycheckCell dateLabel] setText: [formatter stringFromDate: [paycheck date]]];
    
    [[paycheckCell periodLabel] setTextColor: UIColorFromRGB(ah_blue)];
    [[paycheckCell dateLabel] setTextColor: UIColorFromRGB(ah_blue)];
    
    return paycheckCell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[paychecks objectAtIndex: section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [paychecks count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [view setBackgroundColor: UIColorFromRGB(ah_blue)];
    UILabel * yearLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [yearLabel setTextAlignment: NSTextAlignmentCenter];
    [yearLabel setBackgroundColor: [UIColor clearColor]];
    [yearLabel setTextColor: [UIColor whiteColor]];
    [yearLabel setFont: app_font(18)];
    [yearLabel setText: [(Paycheck*)[[paychecks objectAtIndex: section] objectAtIndex:0] year]];
    
    [view addSubview: yearLabel];
    
    return view;
}

@end
