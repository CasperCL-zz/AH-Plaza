//
//  InstructionsManager.h
//  AH Plaza
//
//  Created by Casper Eekhof on 08-08-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject <NSCoding>

+ (id)sharedInstance;

@property (nonatomic) BOOL autologinEnabled;
@property (nonatomic) BOOL planningInstructionsDisplayed;

@end
