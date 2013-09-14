//
//  SettingsViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 22-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Popup.h"
#import "../../Helpers/Constants.h"

@interface SettingsViewController ()

@property Popup *popup;

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
    
    [_keepLoggedInSwitch setOn: [[SettingsManager sharedInstance] autologinEnabled]];
    [_notificationSwitch setOn: [[SettingsManager sharedInstance] notificationPaymentEnabled]];
    
    [_keepLoggedInSwitch setOnTintColor: UIColorFromRGB(ah_blue)];
    [_notificationSwitch setOnTintColor: UIColorFromRGB(ah_blue)];
    
    _resetButton.layer.cornerRadius = 10;
    _resetButton.layer.masksToBounds = YES;
    
    
    _popup = [[Popup alloc] initWithView: self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setKeepLoggedInSwitch:nil];
    [self setResetButton:nil];
    [self setNotificationSwitch:nil];
    [self setSwitches:nil];
    [super viewDidUnload];
}
- (IBAction)autoLoginSliderValueChanged:(id)sender {
    [[SettingsManager sharedInstance] setAutologinEnabled: [_keepLoggedInSwitch isOn]];
}
- (IBAction)notificationSwitchValueChanged:(id)sender {
    [[SettingsManager sharedInstance] setNotificationPaymentEnabled: [_notificationSwitch isOn]];
}

- (IBAction)resetSettings:(id)sender {
    UIColor *bgColor = UIColorFromRGB(ah_blue);
    
    [_popup setFont: @"STHeitiTC-Light"];
    [_popup setButton1BackgroundImage:[UIImage imageNamed:@"ah-button"] forState:UIControlStateNormal];
    [_popup setButton2BackgroundImage:[UIImage imageNamed:@"ah-button"] forState:UIControlStateNormal];
    [_popup setTextColor: bgColor highlighted: [UIColor whiteColor]];
    [_popup showPopupWithAnimationDuration: 0.5 withText:@"Weet je zeker dat je alle instellingen wilt terugzetten?" withButton1Text:@"Ja" withButton2Text:@"Nee" withResult:^(RESULT result) {
        if (result == OKAY) {
            [[SettingsManager sharedInstance] reset];
            for (UISwitch *swtch in _switches) {
                [swtch setOn: NO animated: YES];
            }
        }
    } onCompletion:^(BOOL finished) {}];
    
    
}
@end
