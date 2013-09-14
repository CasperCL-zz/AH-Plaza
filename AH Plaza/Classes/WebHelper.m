//
//  WebHelper.m
//  AH Plaza
//
//  Created by Casper Eekhof on 23-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "WebHelper.h"
#import "Week.h"
#import "HTMLParser.h"

@implementation WebHelper

NSString * HOME_URL = @"https://plaza.ah.nl/";
NSString * TIMETABLE_URL = @"https://plaza.ah.nl/store_rendering_p1/wps/myportal/ahplaza/rooster";
NSString * PAY_CHECK_BASE = @"https://plaza.ah.nl/wps/AppLaunch2/AppLaunchServlet?appid=clrpay";
NSString * LOGIN_FAIL_URL = @"https://plaza.ah.nl/pkmslogin.form";
NSString * LOGIN_SCCS_URL = @"https://plaza.ah.nl/cgi-bin/final.pl";
NSString * CHANGE_PASS_URL = @"https://plaza.ah.nl/pkmspasswd";


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (id)sharedInstance {
    static WebHelper *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[WebHelper alloc] init]; });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setDelegate: self];
        NSURLRequest *urlReq = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString: HOME_URL]]; //plaza.ah.nl
        [self loadRequest: urlReq];
    }
    return self;
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
    [self stringByEvaluatingJavaScriptFromString: req];
    req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"password\")[0].value='%@'", password];
    [self stringByEvaluatingJavaScriptFromString: req];
    
    [self submitForm];
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
    NSLog(@"%@ ",     [self stringByEvaluatingJavaScriptFromString: req]);
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
    NSString *hidfldval = [self stringByEvaluatingJavaScriptFromString: @"document.getElementById('hdfld').value"];
    NSString *strURL = [[NSString alloc] initWithFormat: @"%@%@%@", PAY_CHECK_BASE,  @"&", hidfldval];
    NSURLRequest * urlReq = [[NSURLRequest alloc] initWithURL: [[NSURL alloc] initWithString: strURL]];
    [self loadRequest: urlReq];
    [NSException raise:@"Unimplemented Exception" format:@"Unimplemented method loadPayCheckPage"];
}


-(void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    NSString * currentURL = [self stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    if(_loginCallback) {
        if([currentURL isEqualToString: LOGIN_SCCS_URL]){
            _loginCallback(nil);
            [self stopLoading];
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
    NSLog(@"loaded: %@", currentURL);
    NSLog(@"Body: %@", [self stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"]);
    
    
    // Check if the session is not expired
    if(![currentURL isEqualToString: @"https://plaza.ah.nl/pkmslogout?filename=wpslogout.html"]) {
        if([currentURL isEqualToString: HOME_URL]) {
            _homePageLoadedCallback();
        } else if ([currentURL isEqualToString: TIMETABLE_URL]) {
            // Parse the HTML to weeks
            NSArray *weeks = [[HTMLParser sharedInstance] htmlToWeeks: self];
            if([weeks count] != 0)
                _timetableCallback(weeks);
        } else if ([currentURL isEqualToString: LOGIN_FAIL_URL]) {
            NSMutableArray *errors = [[NSMutableArray alloc] init];
            
            NSString *changePasswordPageCheck = @"document.getElementsByName('new')[0]";
            NSString *javaScriptResponse = [self stringByEvaluatingJavaScriptFromString: changePasswordPageCheck];
            if(![javaScriptResponse isEqualToString: @"undefined"]){
                [errors addObject: @"Je moet je wachtwoord wijzigen"];
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
        }
    } else {
        NSMutableArray *errors = [[NSMutableArray alloc] init];
        [errors addObject: @"U moet opnieuw inloggen"];
        _loginCallback(errors);
        NSLog(@"Session expired");
        [self reauthenticate];
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSInteger errorCode = [error code];
    
    if(errorCode != NSURLErrorCancelled) { // Ignore fast redirection
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
