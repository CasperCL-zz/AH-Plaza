//
//  HTMLParser.h
//  AH Plaza
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLParser : NSObject

+ (id)sharedInstance;
-(NSArray*) htmlToWeeks: (UIWebView *) webHelper;

@end
