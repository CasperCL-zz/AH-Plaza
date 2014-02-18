//
//  HTMLParser.h
//  AH Plaza
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paycheck.h"
#import <CoreData/CoreData.h>

@interface AHParser : NSObject

+ (id)sharedInstance;
-(NSArray*) htmlToWeeks: (UIWebView *) webHelper;
-(NSArray*) htmlToPaychecks: (UIWebView *) webHelper;

-(Paycheck*) parseSavedPaycheck:(NSManagedObject*)object;

@end
