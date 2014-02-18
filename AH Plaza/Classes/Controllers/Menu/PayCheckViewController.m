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
#import "Popup.h"
#import "UIImage+Tint.h"
#import "APIData.h"

@interface PayCheckViewController ()

@property Popup * popup;

@end

@implementation PayCheckViewController

static NSArray * paychecks;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _popup = [[Popup alloc] initWithView: self.view];
    
    UIColor *bgColor = UIColorFromRGB(ah_blue);
    [_popup setFont: @"STHeitiTC-Light"];
    
    [_popup setButton1BackgroundImage:[UIImage imageWithColor: bgColor] forState:UIControlStateNormal];
    [_popup setButton2BackgroundImage:[UIImage imageWithColor: bgColor] forState:UIControlStateNormal];
    [_popup setTextColor: bgColor highlighted: [UIColor whiteColor]];    [[_popup dialogLabel] setTextColor: bgColor];
    [[_popup button1] setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [[_popup button2] setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [[_popup activityIndicator] setColor: bgColor];
    
    
    if(!paychecks)
        // Retreive the paychecks
        [[APIData sharedInstance] loadPaychecks:^(NSArray *paychecksArray, NSError *error) {
            
            if(!paychecksArray || ![paychecksArray count] || error) {
                [self renewPaychecks];
            } else {
                Paycheck * lastPaycheck = [[paychecksArray objectAtIndex:0] objectAtIndex: 0];
                NSTimeInterval lastPaycheckTI = ceil(fabs([lastPaycheck.date timeIntervalSinceNow] / (60 * 60 * 24)));
                
                
                if (lastPaycheckTI > 28) {
                    NSString * message;
                    if(lastPaycheckTI < 56)
                        message = @"Er is een nieuwe loonstrook beschikbaar, wil je deze ophalen?";
                    else
                        message = @"Er zijn nieuwe loonstroken, wil je deze ophalen?";
                    
                    [_popup showPopupWithAnimationDuration:.4f withText: message  withButton1Text:@"Ja" withButton2Text:@"Later" withResult:^(RESULT result) {
                        if(result == OKAY){
                            [self renewPaychecks];
                        } else {
                            [_popup hidePopupWithAnimationDuration:.4f onCompletion: nil];
                        }
                    } onCompletion: nil];
                }
                [_popup hidePopupWithAnimationDuration:.5f onCompletion:^(BOOL finished) {
                    
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
        }];
}

-(void) renewPaychecks {
    
    [_popup showPopupWithAnimationDuration:.2f withActivityIndicatorAndText: @"Loonstroken laden" onCompletion:^(BOOL finished) {
        [[APIClient sharedInstance] loadPayCheckPage:^(NSArray *paychecksArray, NSError * error) {
            [_popup hidePopupWithAnimationDuration:.5f onCompletion:^(BOOL finished) {
                
                if([paychecksArray count] > 0 && !error){
                    NSLog(@"Downloaded everything (%i paychecks)", [paychecks count]);
                    paychecks = paychecksArray;
                    
                    [[APIData sharedInstance] savePaychecks:paychecks onCompletion: nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                    });
                } else {
                    // show errors
                }
                
            }];
        }];
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
