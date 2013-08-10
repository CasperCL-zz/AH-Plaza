//
//  SettingsViewController.h
//  AH Plaza
//
//  Created by Casper Eekhof on 22-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *keepLoggedInSwitch;
- (IBAction)autoLoginSliderValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end
