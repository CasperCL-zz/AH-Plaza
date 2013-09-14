//
//  ChangePasswordViewController.h
//  AH Plaza
//
//  Created by Casper Eekhof on 08-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Popup.h"

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *formView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;

@property Popup * popup;

@property NSString * username;
@property NSString * oldPassword;

- (IBAction)changePasswordButtonTouchedUpInside:(id)sender;
- (IBAction)overlayButtonPressed:(id)sender;

@end
