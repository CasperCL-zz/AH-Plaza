//
//  WebHelper.h
//  AH Plaza
//
//  Created by Casper Eekhof on 23-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebHelper : UIWebView <UIWebViewDelegate>


typedef void (^callbackTimetable)(NSArray* weeks);
typedef void (^callbackLogin)(NSArray* errors);

+ (id)sharedInstance;
- (void)login: (NSString*) username WithPassword: (NSString*) password onCompletion: (callbackLogin) callback;
- (void)loadTimetablePage: (callbackTimetable) callback;


@property (strong, atomic)callbackTimetable timetableCallback;
@property (strong, atomic)callbackLogin loginCallback;


@end
