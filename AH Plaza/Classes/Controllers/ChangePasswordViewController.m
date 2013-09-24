//
//  ChangePasswordViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 08-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "WebHelper.h"
#import "Constants.h"
#import "NSString+JRStringAdditions.h"
#import "MenuViewController.h"
#import "../Keys.h"
#import "NSData+AES256.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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
    
    _changePasswordButton.layer.cornerRadius = 5;
    _changePasswordButton.layer.masksToBounds = YES;
    
    _formView.layer.cornerRadius = 5;
    _formView.layer.masksToBounds = YES;
    
    UIColor *bgColor = UIColorFromRGB(ah_blue);
    _popup = [[Popup alloc] initWithView: self.view];
    [_popup setFont: @"STHeitiTC-Light"];
    [_popup setButton1BackgroundImage:[UIImage imageNamed:@"ah-button"] forState:UIControlStateNormal];
    [_popup setButton2BackgroundImage:[UIImage imageNamed:@"ah-button"] forState:UIControlStateNormal];
    [_popup setTextColor: bgColor highlighted: [UIColor whiteColor]];
    [_popup setDialogBackgroundColor: bgColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) changePasswordButtonTouchedUpInside:(id)sender {
    
    [_passwordTextField resignFirstResponder];
    [_checkNewPasswordTextField resignFirstResponder];
    
    NSString * password = [_passwordTextField text];
    NSString * error = [self checkCredentials: password check: [_checkNewPasswordTextField text]];
    
    if(!error){
        [[WebHelper sharedInstance] changePassword: password withOldPassword: _oldPassword onCompletion:^(NSArray *errors) {
            if([errors count]) {
                [_popup showPopupWithAnimationDuration:.5 withText:[errors objectAtIndex:0] withButtonText:@"OK" withResult:^(RESULT result) {
                    [_popup hidePopupWithAnimationDuration:.5 onCompletion:^(BOOL finished) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                } onCompletion:^(BOOL finished) {}];
            } else {
                [_popup showPopupWithAnimationDuration:.5 withText:@"Je wachtwoord is gewijzigd" withButtonText:@"OK" withResult:^(RESULT result) {
                    [self saveCredentials];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                    MenuViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
                    [self presentViewController:vc animated:YES completion:^{}];
                } onCompletion:^(BOOL finished) {}];
            }
        }];
    } else {
        [_popup showPopupWithAnimationDuration:.5 withText:error withButtonText:@"OK" withResult:^(RESULT result) {} onCompletion:^(BOOL finished) {}];
    }
}


- (void) saveCredentials {
	NSString *username = _username;
    NSString *password = [_passwordTextField text];
    _username = nil;
    
	NSData *plainUsername = [username dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plainPassword = [password dataUsingEncoding:NSUTF8StringEncoding];
	NSData *encryptedUsername = [plainUsername AES256EncryptWithKey: UsernameEncryptionKey];
	NSData *encryptedPassword = [plainPassword AES256EncryptWithKey: PasswordEncryptionKey];
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *fileLocation =  [[NSString alloc] initWithFormat: @"%@/%@", documentsDirectory , @"user.ahpu"];
    [NSKeyedArchiver archiveRootObject:[[NSArray alloc] initWithObjects: encryptedUsername, encryptedPassword, nil] toFile: fileLocation];
}

- (IBAction)overlayButtonPressed:(id)sender {
    [_passwordTextField resignFirstResponder];
    [_checkNewPasswordTextField resignFirstResponder];
}

- (NSString*) checkCredentials: (NSString*) firstPassword check:(NSString*) secondPassword{
    NSString *error = nil;
    
    /*
     Het wachtwoord moet anders zijn dan de vorige 6 wachtwoorden
     Het wachtwoord mag niet lijken op uw voornaam en of achternaam
     */
    if (![firstPassword isEqualToString: secondPassword]) {
        error = @"Wachtwoorden zijn niet gelijk aan elkaar";
    } else if ([firstPassword length] < 8){
        error = @"Het wachtwoord moet minimaal 8 posities lang zijn";
    } else if ([firstPassword isEqualToString: _oldPassword]){
        error = @"Het wachtwoord moet anders zijn dan de vorige 6 wachtwoorden";
    } else if ([firstPassword containsString: @"#"] || [firstPassword containsString: @"+"] || [firstPassword containsString: @"&"]|| [firstPassword containsString: @"<"]){
        error = @"Het wachtwoord mag geen spatie of # of + of & of < bevatten";
    } else if([firstPassword isEqualToString: _username]) {
        error = @"Het wachtwoord mag niet gelijk zijn aan uw gebruikersnaam";
    } else {
        char checkedChars[[firstPassword length]];
        int index = 0;
        int seenChar = 0;
        int seenNumber = 0;
        for (int i = 0; i < [firstPassword length]; i++) {
            if(!(seenChar >= 3)) {
                seenChar = 0;
                char c = [firstPassword characterAtIndex: i];
                
                for (int j = 0; j < index; j++) {
                    if (c == checkedChars[j]) {
                        seenChar++;
                        if(seenChar >= 3){
                            break;
                        }
                    }
                }
                
                if(isdigit(c))
                    seenNumber++;
                
                checkedChars[index] = c;
                index++;
            } else if (seenChar >= 3){
                error = @"Het wachtwoord mag maximaal 2 keer hetzelfde teken bevatten";
                break;
            }
        }
        if(!error && seenNumber < 2)
            error = @"Het wachtwoord moet minimaal 2 cijfers bevatten";
        
    }
    
    return  error;
}

@end
