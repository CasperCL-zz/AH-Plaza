//
//  WebHelper.m
//  AH Plaza
//
//  Created by Casper Eekhof on 23-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "APIClient.h"
#import "Week.h"
#import "AHParser.h"
#import "NSString+JRStringAdditions.h"

@implementation APIClient

NSString * HOME_URL = @"https://plaza.ah.nl/";
NSString * TIMETABLE_URL = @"https://plaza.ah.nl/store_rendering_p1/wps/myportal/ahplaza/rooster";
NSString * PAY_CHECK_BASE = @"https://plaza.ah.nl/wps/AppLaunch2/AppLaunchServlet?appid=clrpay";
NSString * LOGIN_FAIL_URL = @"https://plaza.ah.nl/pkmslogin.form";
NSString * LOGIN_SCCS_URL = @"https://plaza.ah.nl/cgi-bin/final.pl";
NSString * CHANGE_PASS_URL = @"https://plaza.ah.nl/pkmspasswd";
NSString * PAYCHECK_URL = @"https://www.mijn-loonstrook.nl/?authcode=";
NSString * LOGIN_FORM = @"<form onsubmit=\"return checkrequired(this)\" method=\"POST\" action=\"/pkmslogin.form\"><font size=\"+2\"><table border=\"0\" width=\"400\"><tbody><tr><td align=\"LEFT\"><ul><li>Gebruikersnaam</li></ul></td><td><input type=\"TEXT\" name=\"username\" size=\"15\" autocomplete=\"off\"></td></tr><tr><td align=\"LEFT\"><ul><li>Wachtwoord</li></ul></td><td><input type=\"PASSWORD\" name=\"password\" size=\"15\" autocomplete=\"off\"></td><input type=\"HIDDEN\" name=\"login-form-type\" value=\"pwd\"></tr></tbody></table></font><br>&nbsp; <input type=\"SUBMIT\" value=\"Aanmelden\"></form>";
NSString *_username;
NSString *_password;
NSString * accountBlockedString  = @"Je account / gebruikersnaam is geblokkeerd. Gebruik de onderstaande link om via \"SelfHelp\" je wachtwoord opnieuw in te voeren of bel de helpdesk.";

BOOL calledPaycheckParser;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (id)sharedInstance {
    static APIClient *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[APIClient alloc] init]; });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setDelegate: self];
        [self loadHomePage];
        calledPaycheckParser = NO;
    }
    return self;
}

- (void) loadHomePage {
    NSURLRequest *urlReq = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString: HOME_URL]]; //plaza.ah.nl
    [self loadRequest: urlReq];
}

- (void)login: (NSString*) username WithPassword: (NSString*) password onCompletion:(callbackLogin) callback {
    _loginCallback = callback;
    
    NSArray * err1;
    if(_internetOffline) {
        err1 = [[NSArray alloc] initWithObjects:@"Geen internetverbinding", nil];
        callback(err1);
        return;
    }
    
    
    // Fill in the credentials in the webform via JavaScript
    NSString *req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"username\")[0].value='%@'", username];
    
    
    NSString *result = [self stringByEvaluatingJavaScriptFromString: req];
    if([result length] != 0) {
        req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"password\")[0].value='%@'", password];
        [self stringByEvaluatingJavaScriptFromString: req];
        [self submitForm];
    } else {
        [self loadHomePage];
        _username = username;
        _password = password;
    }
}

- (void) changePassword: (NSString*) password withOldPassword: (NSString*) oldPassword onCompletion:(callbackErrors) callback {
    _changePasswordCallback = callback;
    NSArray * err1;
    if(_internetOffline) {
        err1 = [[NSArray alloc] initWithObjects:@"Geen internetverbinding", nil];
        callback(err1);
        return;
    }
    
    // Fill in the credentials in the webform via JavaScript
    NSString *req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"old\")[0].value='%@'", oldPassword];
    [self stringByEvaluatingJavaScriptFromString: req];
    req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"new\")[0].value='%@'", password];
    [self stringByEvaluatingJavaScriptFromString: req];
    req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"new2\")[0].value='%@'", password];
    [self stringByEvaluatingJavaScriptFromString: req];
    
    [self submitForm];
}

- (void) submitForm {
    // Submit the form
    [self stringByEvaluatingJavaScriptFromString: @"document.forms[0].submit();"];
}


- (void) loadTimetablePage: (void (^)(NSArray* weeks)) completion {
    _timetableCallback = completion;
    NSURLRequest *urlReq = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString: TIMETABLE_URL]];
    [self loadRequest: urlReq];
}

- (void)loadPayCheckPage: (callbackPayCheck) callback {
    _paycheckCallback = callback;
    
    // Makes the uiwebview load the page
    
    NSString *strURL = [[NSString alloc] initWithFormat: @"%@%@%@", PAY_CHECK_BASE,  @"&", @"contextFromSession=true&vpname=ahstore&brand=Albert%20Heijn&country=NL&language=nl&policyPath=/plaza/store/ah"];
    NSURLRequest * urlReq = [[NSURLRequest alloc] initWithURL: [[NSURL alloc] initWithString: strURL]];
    [self loadRequest: urlReq];
    
}


-(void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    NSString * currentURL = [self stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    if(_loginCallback) {
        if([currentURL isEqualToString: LOGIN_SCCS_URL]){
            _loginCallback(nil);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            _loginCallback = nil;
        }
    }
    if(_changePasswordCallback && [currentURL isEqualToString: LOGIN_SCCS_URL]){
        _changePasswordCallback(nil);
        _changePasswordCallback = nil;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    NSString * currentURL = [self stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    // Check if the session is not expired
    if(![currentURL isEqualToString: @"https://plaza.ah.nl/pkmslogout?filename=wpslogout.html"]) {
        if([currentURL isEqualToString: HOME_URL]) {
            if(_homePageLoadedCallback){
                _homePageLoadedCallback();
                _homePageLoadedCallback = nil;
            } else { // auto login
                [self login:_username WithPassword:_password onCompletion: _loginCallback];
                _username = nil;
                _password = nil;
            }
        } else if ([currentURL isEqualToString: TIMETABLE_URL]) {
            // Parse the HTML to weeks
            NSArray *weeks = [[AHParser sharedInstance] htmlToWeeks: self];
            if([weeks count] != 0)
                _timetableCallback(weeks);
        } else if ([currentURL isEqualToString: LOGIN_FAIL_URL]) {
            NSMutableArray *errors = [[NSMutableArray alloc] init];
            
            NSString *changePasswordPageCheck = @"document.getElementsByName('new')[0]";
            NSString *javaScriptResponse = [self stringByEvaluatingJavaScriptFromString: changePasswordPageCheck];
            if([javaScriptResponse length] > 0){ // if the page contains the a tag with the name: 'new'
                [errors addObject: @"Je moet je wachtwoord wijzigen"];
            } else if ([[self stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString: @"AH Plaza - Account Locked Out"]
                       || [[self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"] containsString: accountBlockedString]){
                [errors addObject: @"Je account is geblokkeerd na te veel foutive pogingen\n Vraag bij je filiaal, om je account te resetten"];
                [self loadHTMLString: LOGIN_FORM baseURL:[[NSURL alloc] initWithString: HOME_URL]];
            } else {
                [errors addObject: @"Gebruikersnaam of wachtwoord is incorrect"];
            }
            
            
            _loginCallback(errors);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            [self stopLoading];
            _loginCallback = nil;
        } else if([currentURL isEqualToString: CHANGE_PASS_URL]){
            if(_changePasswordCallback) {
                NSArray *error = @[@"Je wachtwoord voldoet niet aan de eisen"];
                _changePasswordCallback(error);
                _changePasswordCallback = nil;
            }
        } else if([currentURL hasPrefix: PAYCHECK_URL]) {
            if(!calledPaycheckParser) {
                calledPaycheckParser = YES;
                [self performSelector:@selector(paychecksLoaded) withObject:nil afterDelay:8.0f];
            }
        }
    } else {
        NSMutableArray *errors = [[NSMutableArray alloc] init];
        [errors addObject: @"U moet opnieuw inloggen"];
        _loginCallback(errors);
        NSLog(@"Session expired");
        [self reauthenticate];
    }
}
-(void) paychecksLoaded {
    NSLog(@"HTML size: %i ", [[self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"] length]);
    if([[self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"] length] > 300) {
        calledPaycheckParser = NO;
        NSArray *paychecks = [[AHParser sharedInstance] htmlToPaychecks: self];
        _paycheckCallback(paychecks, nil);
    } else {
        [self performSelector:@selector(paychecksLoaded) withObject:nil afterDelay:3.0f];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSInteger errorCode = [error code];
    
    if(errorCode != NSURLErrorCancelled) { // Ignore fast redirection error
        NSLog(@"An error occured in the webview with Error code: %i", errorCode);
        switch (errorCode) {
            case -1009: // Error Domain=NSURLErrorDomain "The Internet connection appears to be offline."
                _internetOffline = YES;
                break;
            default:
                NSLog(@"Unhandeled error: \n%@\n", error);
        }
    }
}

- (void) reauthenticate {
    [NSException raise:@"Session Expired" format:@"Needs method for reauthentication"];
    NSURLRequest *urlReq = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString: HOME_URL]];
    [self loadRequest: urlReq];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
