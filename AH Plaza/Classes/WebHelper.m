//
//  WebHelper.m
//  AH Plaza
//
//  Created by Casper Eekhof on 23-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "WebHelper.h"

@implementation WebHelper

NSString * TIMETABLE_URL = @"https://plaza.ah.nl/store_rendering_p1/wps/myportal/ahplaza/rooster";
NSString * LOGIN_FAIL_URL = @"https://plaza.ah.nl/pkmslogin.form";
NSString * LOGIN_SCCS_URL = @"https://plaza.ah.nl/cgi-bin/final.pl";


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
        NSURLRequest *urlReq = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"https://plaza.ah.nl/"]]; //plaza.ah.nl
        [self loadRequest: urlReq];
    }
    return self;
}

- (void) loadTimetablePage: (void (^)(NSArray* weeks)) completion {
    _timetableCallback = completion;
}


- (void)login: (NSString*) username WithPassword: (NSString*) password onCompletion:(callbackLogin)callback {
    _loginCallback = callback;

    // Fill in the credentials in the webform via JavaScript
    NSString *req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"username\")[0].value='%@'", username];
    [self stringByEvaluatingJavaScriptFromString: req];
    req = [[NSString alloc] initWithFormat:@"document.getElementsByName(\"password\")[0].value='%@'", password];
    [self stringByEvaluatingJavaScriptFromString: req];
    
    // Submit the form
    [self stringByEvaluatingJavaScriptFromString: @"document.forms[0].submit();"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString * currentURL = [self stringByEvaluatingJavaScriptFromString:@"document.URL"];
    NSLog(@"Current URL: %@", currentURL);
    
    if ([currentURL isEqualToString: TIMETABLE_URL]) {
        // Parse the HTML to weeks
        NSMutableArray * weeks = [[NSMutableArray alloc] init];
        NSString *html = [self stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        
        NSLog(@"%@", html);
        
        _timetableCallback(weeks);
    } else if([currentURL isEqualToString: LOGIN_SCCS_URL]){
        _loginCallback(nil);
    } else if ([currentURL isEqualToString: LOGIN_FAIL_URL]) {
        NSMutableArray *errors = [[NSMutableArray alloc] init];
        [errors addObject: @"Gebruikersnaam of wachtwoord is incorrect"];
        _loginCallback(errors);
    }
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
