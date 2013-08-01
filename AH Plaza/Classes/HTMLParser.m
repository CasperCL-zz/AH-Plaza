//
//  HTMLParser.m
//  AH Plaza
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "HTMLParser.h"
#import "Week.h"

@implementation HTMLParser

+ (id)sharedInstance {
    static HTMLParser *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[HTMLParser alloc] init]; });
    
    return instance;
}


-(NSArray*) htmlToWeeks: (UIWebView *) webHelper {
    NSString *html = [webHelper stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    NSMutableArray * weeks = [[NSMutableArray alloc] init];
    
    // Loop over all weeks
    int weekCounter = 0;
    NSString *startingID = [[NSString alloc] initWithFormat:@"viewPC_7_O49HSGU21834502RCI9ODP2022_:tableEx1:%i", weekCounter];
    while ([html rangeOfString: startingID].location != NSNotFound) {
        Week *tmp = [[Week alloc] init];
        
        
        // Get the Week ID
        NSString *javascriptStringWeekID;
        if(!weekCounter)
            javascriptStringWeekID = @"document.getElementById('viewPC_7_O49HSGU21834502RCI9ODP2022_:tableEx1:0:text12').innerHTML";
        else
            javascriptStringWeekID = [[NSString alloc] initWithFormat:@"document.getElementById('viewPC_7_O49HSGU21834502RCI9ODP2022_:tableEx1:%i:text2').innerHTML", weekCounter];
        
        NSString * weekID = [webHelper stringByEvaluatingJavaScriptFromString: javascriptStringWeekID];
        [tmp setWeekID: weekID];
        
        
        // Get the date from/till
        NSString *javascriptStringFromTillDate = [[NSString alloc] initWithFormat: @"document.getElementById('viewPC_7_O49HSGU21834502RCI9ODP2022_:tableEx1:%i:text6').innerHTML", weekCounter];
        NSString * fromTillDate = [webHelper stringByEvaluatingJavaScriptFromString: javascriptStringFromTillDate];
        [tmp setFromTillDate: fromTillDate];
        
        // Array to hold the from/till dictionary containing working times
        NSMutableArray * fromTill = [[NSMutableArray alloc] init];
        int dayCounter = 3;
        
        // Enumerate over all the days and fill the data
        for(int textCounter = 18; textCounter <= 30; textCounter+=2, dayCounter++) {
            NSString *javascriptFunctionFrom = [[NSString alloc] initWithFormat: @"document.getElementById('viewPC_7_O49HSGU21834502RCI9ODP2022_:tableEx1:%i:tableEx%i:%i:text%i').innerHTML", weekCounter, dayCounter, 0, textCounter];
            NSString * currentDayFrom = [webHelper stringByEvaluatingJavaScriptFromString:javascriptFunctionFrom];
            NSString *javascriptFunctionTill = [[NSString alloc] initWithFormat: @"document.getElementById('viewPC_7_O49HSGU21834502RCI9ODP2022_:tableEx1:%i:tableEx%i:%i:text%i').innerHTML", weekCounter, dayCounter, 1, textCounter];
            NSString * currentDayTill = [webHelper stringByEvaluatingJavaScriptFromString:javascriptFunctionTill];
            
            NSArray *keys = [[NSArray alloc] initWithObjects:@"from", @"till", nil];
            NSArray *objects = [[NSArray alloc] initWithObjects: currentDayFrom, currentDayTill, nil];
            NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];
            [fromTill addObject: tmpDict];
        }
        
        NSArray * keys = [[NSArray alloc] initWithObjects:
                          @"monday",
                          @"tuesday",
                          @"wednesday",
                          @"thursday",
                          @"friday",
                          @"saturday",
                          @"sunday",
                          nil];
        NSDictionary * workingTimes = [[NSDictionary alloc] initWithObjects: fromTill forKeys: keys];
        [tmp setWorkingTimes: workingTimes];
        
        // Add the parsed week
        [weeks addObject: tmp];
        
        weekCounter++;
        startingID = [[NSString alloc] initWithFormat:@"viewPC_7_O49HSGU21834502RCI9ODP2022_:tableEx1:%i", weekCounter];
    }
    return weeks;
}

@end
