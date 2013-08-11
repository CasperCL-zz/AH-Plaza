//
//  LoginViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 21-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WebHelper.h"
#import "NSData+AES256.h"
#import "SettingsManager.h"
#import "../Keys.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

int credentialViewMoved = 0;
BOOL isInTransition;



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
    [WebHelper sharedInstance];
    _popup = [[Popup alloc] initWithView: self.view];
    [_popup setFont: @"STHeitiTC-Light"];
    
    [self.view setBackgroundColor: [self colorWithHexString:@"2F7FB9"]];
    
	// Do any additional setup after loading the view.
    _credentialsView.layer.cornerRadius = 10;
    _credentialsView.layer.masksToBounds = YES;
    
    _loginButton.layer.cornerRadius = 10;
    _loginButton.layer.masksToBounds = YES;
    
    //
    
    [_usernameTextField setAutocorrectionType: UITextAutocorrectionTypeNo];
    
    [self showCredentialsView:^(BOOL finished) {}];
    if([[SettingsManager sharedInstance] autologinEnabled]){
        NSString *documentsDirectory = [NSHomeDirectory()
                                        stringByAppendingPathComponent:@"Documents"];
        NSString *fileLocation =  [[NSString alloc] initWithFormat: @"%@/%@", documentsDirectory , @"user.ahpu"];
        
        NSArray *userData = [NSKeyedUnarchiver unarchiveObjectWithFile: fileLocation];
        
        NSData *plainUsername = [[userData objectAtIndex: 0] AES256DecryptWithKey: UsernameEncryptionKey];
        NSData *plainPassword = [[userData objectAtIndex: 1] AES256DecryptWithKey: PasswordEncryptionKey];
        
//        printf("%s\n", [[[NSString alloc] initWithData:plainUsername encoding:NSUTF8StringEncoding] UTF8String]);
//        printf("%s\n", [[[NSString alloc] initWithData:plainPassword encoding:NSUTF8StringEncoding] UTF8String]);
        [_usernameTextField setText: [[NSString alloc] initWithData:plainUsername encoding:NSUTF8StringEncoding]];
        [_passwordTextField setText: [[NSString alloc] initWithData:plainPassword encoding:NSUTF8StringEncoding]];
        [self login];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showCredentialsView: (void (^)(BOOL finished))completion {
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
        completion(finished);
    }];
}

- (IBAction)backgroundButtonClicked:(id)sender {
    if(!isInTransition) {
        if(_originalFrame.origin.x == 0){
            _originalFrame = _credentialsView.frame;
        }
        
        [_usernameTextField resignFirstResponder];
        [_passwordTextField resignFirstResponder];
        [self moveToDefaultLocation:^(BOOL finished) {}];
    }
}

- (void) moveCredentialsViewUp: (int) y completion:(void (^)(BOOL finished))completion {
    if(!credentialViewMoved){
        _originalFrame = _credentialsView.frame;
        CGRect newFrame = _credentialsView.frame;
        newFrame.origin.y -= y;
        [UIView animateWithDuration:0.5 delay: 0 options:0 animations:^{
            _credentialsView.frame = newFrame;
        } completion:^(BOOL finished) {
            completion(finished);
        }];
        credentialViewMoved++;
    }
}

- (void) moveToDefaultLocation:(void (^)(BOOL finished))completion {
    [UIView animateWithDuration:0.5 delay: 0 options:0 animations:^{
        _credentialsView.frame = _originalFrame;
    } completion:^(BOOL finished) {
        credentialViewMoved = 0;
        completion(finished);
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveCredentialsViewUp: 170 completion: ^(BOOL finished) {}];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if(textField == _usernameTextField) {
        [self moveCredentialsViewUp: 170 completion: ^(BOOL finished) {}];
        credentialViewMoved = 2;
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField){
        [_usernameTextField resignFirstResponder];
        [_passwordTextField resignFirstResponder];
        
        [self login];
    
    }
    return YES;
}

- (void) checkCredentials:(void (^)(NSArray * error))completion {
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    if([[_usernameTextField text] isEqualToString:@""]){
        [errors addObject: @"Vul een gebruikersnaam in."];
    }
    if([[_passwordTextField text] isEqualToString:@""]){
        [errors addObject: @"Vul een wachtwoord in."];
    }
    
    // Do not check if the credentials are valid (this is a long and uncessary process for now)
    if([errors count] > 0) {
        completion(errors);
        return;
    }
    
    [[WebHelper sharedInstance] login:[_usernameTextField text] WithPassword:[_passwordTextField text] onCompletion:^(NSArray *errors) {
        completion(errors);
    }];
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [self login];
}


- (void) login {
    [self moveToDefaultLocation:^(BOOL finished) {
        [_popup showPopupWithAnimationDuration:1.0 withActivityIndicatorAndText:@"Inloggen.." onCompletion:^(BOOL finished) {
            [self checkCredentials:^(NSArray *error) {
                if([error count] == 0) {
                    [_popup hidePopupWithAnimationDuration:1.0 onCompletion:^(BOOL finished) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MenuNavigationController"];
                        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
                        [vc setModalTransitionStyle: UIModalTransitionStyleCrossDissolve];
                        
                        [self saveCredentials];
                        sleep(0.3f);
                        [self zoomIntoCredentialsView:^(BOOL finished) {
                            [self presentModalViewController:vc animated:NO];
                        }];
                    }];
                } else {
                    NSLog(@"error");
                    [_popup hidePopupWithAnimationDuration:0.0 onCompletion:^(BOOL finished) {
                        [_popup showPopupWithAnimationDuration:0.0 withText:[error objectAtIndex:0] withButtonText:@"OK" withResult:^(RESULT result) {} onCompletion:^(BOOL finished) {}];
                    }];
                }
            }];
            
        }];
    }];

}

- (void) saveCredentials {
	NSString *username = [_usernameTextField text];
    NSString *password = [_passwordTextField text];
    
	NSData *plainUsername = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainPassword = [password dataUsingEncoding:NSUTF8StringEncoding];
	NSData *encryptedUsername = [plainUsername AES256EncryptWithKey: UsernameEncryptionKey];
	NSData *encryptedPassword = [plainPassword AES256EncryptWithKey: PasswordEncryptionKey];
    
    NSString *documentsDirectory = [NSHomeDirectory()
                          stringByAppendingPathComponent:@"Documents"];
    NSString *fileLocation =  [[NSString alloc] initWithFormat: @"%@/%@", documentsDirectory , @"user.ahpu"];
    [NSKeyedArchiver archiveRootObject:[[NSArray alloc] initWithObjects: encryptedUsername, encryptedPassword, nil] toFile: fileLocation];
}

- (void) removeAllViews: (void (^)(BOOL finished)) completion {
    CGRect imgFrame = _ahplazaImage.frame;
    CGRect credFrame = _credentialsView.frame;
    
    imgFrame.origin.y += 1000;
    credFrame.origin.y += 1000;
    [UIView animateWithDuration: 2 animations:^{
        _ahplazaImage.frame = imgFrame;
        _credentialsView.frame = credFrame;
    } completion:completion];
    
}

- (void) zoomIntoCredentialsView: (void (^)(BOOL finished)) completion  {
    isInTransition = YES;
    [_usernameTextField setEnabled: NO];
    [_passwordTextField setEnabled: NO];
    
    [UIView animateWithDuration: 0.5 animations:^{
        _usernameTextField.alpha = 0.0f;
        _passwordTextField.alpha = 0.0f;
        _loginButton.alpha = 0.0f;
        _usernameLabel.alpha = 0.0f;
        _passwordLabel.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        CGRect newFrame = _credentialsView.frame;
        newFrame.size.height = self.view.frame.size.height;
        newFrame.size.width = self.view.frame.size.width;
        newFrame.origin.x = 0;
        newFrame.origin.y = 0;
        
        
        [UIView animateWithDuration: 0.5 animations:^{
            _credentialsView.frame = newFrame;
        } completion:^(BOOL finished) {
            if(finished)
                completion(finished);
        }];
    }];
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)viewDidUnload {
    [self setUsernameLabel:nil];
    [self setPasswordLabel:nil];
    [super viewDidUnload];
}
@end
