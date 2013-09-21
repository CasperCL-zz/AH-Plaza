//
//  PlanningViewController.h
//  AH Plaza
//
//  Created by Casper Eekhof on 23-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Week.h"
#import "AHViewController.h"

@interface PlanningViewController : AHViewController

@property Week * dataObject;


// Instruction dialog
@property (weak, nonatomic) IBOutlet UIView *instructionDialogBackground;
@property (weak, nonatomic) IBOutlet UIView *instructionDialogView;



// The labels
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@property (weak, nonatomic) IBOutlet UILabel *mondayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *tuesdayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *wedsdayFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedsdayTillLabel;
@property (weak, nonatomic) IBOutlet UILabel *wedsdayTotalLabel;

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


@property (weak, nonatomic) IBOutlet UILabel *overallTotal;



@end
