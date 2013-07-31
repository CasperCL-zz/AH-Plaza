//
//  PlanningView.h
//  AH Plaza
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanningView : UIView

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;


@property (weak, nonatomic) IBOutlet UILabel *mondayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *tuesdayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *wednesdayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *thursdayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *fridayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *saturdayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *sundayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *sundayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *overallTotalLabel;

@end
