//
//  Planning.m
//  AH Plaza
//
//  Created by Casper Eekhof on 23-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "Week.h"

@implementation Week

- (id)init
{
    self = [super init];
    if (self) {
        NSArray * keys = [[NSArray alloc] initWithObjects:
                          @"Maandag",
                          @"Dinsdag",
                          @"Woensdag",
                          @"Donderdag",
                          @"Vrijdag",
                          @"Zaterdag",
                          @"Zondag", nil];
        _workingTimes = [[NSMutableDictionary alloc] initWithObjects: nil forKeys: keys];
    }
    return self;
}


@end
