//
//  Planning.h
//  AH Plaza
//
//  Created by Casper Eekhof on 23-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Week : NSObject

@property NSDictionary *workingTimes;
@property NSString *weekID;
@property NSString *fromTillDate;
@property NSString *totalHours;

@end
