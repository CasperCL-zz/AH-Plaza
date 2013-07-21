//
//  LoginViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 21-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

int credentialViewMoved = 0;

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
    _credentialsView.layer.cornerRadius = 10;
    _credentialsView.layer.masksToBounds = YES;
    
    _loginButton.layer.cornerRadius = 10;
    _loginButton.layer.masksToBounds = YES;
    
    _loginHelper = [[UIWebView alloc] init];
    NSURLRequest *urlReq = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://plaza.ah.nl/"]]; //plaza.ah.nl
    [_loginHelper loadRequest: urlReq];
    
    [self showCredentialsView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showCredentialsView {
    CGRect orginal = _ahplazaImage.frame;
    CGRect center = _ahplazaImage.frame;
    CGPoint superCenter = CGPointMake([self.view bounds].size.width / 2.0, [self.view bounds].size.height / 2.0);
    center.origin = superCenter;
    _ahplazaImage.frame = center;
    
    
    _credentialsView.alpha = 0.0f;
    [UIView animateWithDuration:0.5 delay: 0 options:0 animations:^{
        _credentialsView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        _credentialsView.hidden = NO;
    }];
	[UIView animateWithDuration:0.5 delay: 0 options:0 animations: ^{
		_ahplazaImage.frame = orginal;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)backgroundButtonClicked:(id)sender {
    if(_originalFrame.origin.x == 0){
        _originalFrame = _credentialsView.frame;
    }
    
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [self moveToDefaultLocation];
}

- (void) moveCredentialsViewUp: (int) y{
    if(!credentialViewMoved){
        _originalFrame = _credentialsView.frame;
        CGRect newFrame = _credentialsView.frame;
        newFrame.origin.y -= y;
        [UIView animateWithDuration:0.5 delay: 0 options:0 animations:^{
            _credentialsView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
        credentialViewMoved++;
    }
}

- (void) moveToDefaultLocation {
    NSLog(@"%@", NSStringFromCGRect(_originalFrame));
    [UIView animateWithDuration:0.5 delay: 0 options:0 animations:^{
        _credentialsView.frame = _originalFrame;
    } completion:^(BOOL finished) {
        credentialViewMoved = 0;
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveCredentialsViewUp: 160];
    NSString *currentURL = [_loginHelper stringByEvaluatingJavaScriptFromString:@"document.URL"];

    NSLog(@"Current URL: %@", currentURL);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField == _usernameTextField) {
        [self moveCredentialsViewUp: 160];
        credentialViewMoved = 2;
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField){
        [_passwordTextField resignFirstResponder];
        [self checkCredentials];
        [self moveToDefaultLocation];
    }
    return YES;
}

typedef enum {
    USERNAME_EMPTY,
    PASSWD_EMPTY,
    USERNAME_ERR,
    PASSWD_ERR,
    PASSWD_OUTDATED_ERR,
    DATABASE_ERR
} CredentialsError;

- (NSArray*) checkCredentials {
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    CredentialsError err;
    err = -1;

    if([[_usernameTextField text] isEqualToString:@""]){
        err = USERNAME_EMPTY;
        [errors addObject: [[NSNumber alloc] initWithInt: err]];
    }
    if([[_passwordTextField text] isEqualToString:@""]){
        err = PASSWD_EMPTY;
        [errors addObject: [[NSNumber alloc] initWithInt: err]];
    }
    
    // Do not check if the credentials are valid (this is a long and uncessary process for now)
    if(err == USERNAME_EMPTY || err == PASSWD_EMPTY)
        return errors;
    
    // Fill in the credentials in the webform via JavaScript
    NSString *req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"username\")[0].value='%@'", [_usernameTextField text]];
    [_loginHelper stringByEvaluatingJavaScriptFromString: req];
    req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"password\")[0].value='%@'", [_passwordTextField text]];
    [_loginHelper stringByEvaluatingJavaScriptFromString: req];
    // Submit the form
    [_loginHelper stringByEvaluatingJavaScriptFromString: @"document.forms[0].submit();"];

    
    return errors;
}

- (void) logIn {
    
}
- (IBAction)loginButtonPressed:(id)sender {
    NSArray *errors = [self checkCredentials];
    if([errors count] == 0){
        // Go to new view :D
        [_usernameTextField setText: @""];
        [_passwordTextField setText: @""];
    }
}
@end
