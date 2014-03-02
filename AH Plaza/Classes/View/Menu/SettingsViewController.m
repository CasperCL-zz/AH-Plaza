//
//  SettingsViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 22-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsController.h"
#import <QuartzCore/QuartzCore.h>
#import "Popup.h"
#import "../../Helpers/Constants.h"
#import "../../Helpers/UIImage+Tint/UIImage+Tint.h"

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
    
    [_keepLoggedInSwitch setOn: [[SettingsController sharedInstance] autologinEnabled]];
    [_notificationSwitch setOn: [[SettingsController sharedInstance] notificationPaymentEnabled]];
    
    [_keepLoggedInSwitch setOnTintColor: UIColorFromRGB(ah_blue)];
    [_notificationSwitch setOnTintColor: UIColorFromRGB(ah_blue)];
    
    _resetButton.layer.cornerRadius = 10;
    _resetButton.layer.masksToBounds = YES;
    
    CGRect frame = _resetButton.frame;
    frame.origin.y = self.view.frame.size.height - _resetButton.frame.size.height - 20;
    _resetButton.frame = frame;
    
    _popup = [[Popup alloc] initWithView: self.view];
    
    if(iOS6){
        CGFloat moveToRight = 20;
        frame = _keepLoggedInSwitch.frame;
        frame.origin.x += moveToRight;
        _keepLoggedInSwitch.frame = frame;
        
        
        frame = _notificationSwitch.frame;
        frame.origin.x += moveToRight;
        _notificationSwitch.frame = frame;
        
        
        frame = _jobOfferSwitch.frame;
        frame.origin.x += moveToRight;
        _jobOfferSwitch.frame = frame;
    }
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
    [[SettingsController sharedInstance] setAutologinEnabled: [_keepLoggedInSwitch isOn]];
}
- (IBAction)notificationSwitchValueChanged:(id)sender {
    [[SettingsController sharedInstance] setNotificationPaymentEnabled: [_notificationSwitch isOn]];
}

- (IBAction)resetSettings:(id)sender {
    UIColor *bgColor = UIColorFromRGB(ah_blue);
    
    [_popup setFont: @"STHeitiTC-Light"];
    [_popup setButton1BackgroundImage:[UIImage imageWithColor: bgColor] forState:UIControlStateNormal];
    [_popup setButton2BackgroundImage:[UIImage imageWithColor: bgColor] forState:UIControlStateNormal];
    [_popup setTextColor: bgColor highlighted: [UIColor whiteColor]];
    [[_popup dialogLabel] setTextColor: bgColor];
    [[_popup button1] setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [[_popup button2] setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_popup showPopupWithAnimationDuration: 0.5 withText:@"Weet je zeker dat je alle instellingen wilt terugzetten?" withButton1Text:@"Ja" withButton2Text:@"Nee" withResult:^(RESULT result) {
        if (result == OKAY) {
            [[SettingsController sharedInstance] reset];
            for (UISwitch *swtch in _switches) {
                [swtch setOn: NO animated: YES];
            }
        }
    } onCompletion:^(BOOL finished) {}];
    
    
}
@end
