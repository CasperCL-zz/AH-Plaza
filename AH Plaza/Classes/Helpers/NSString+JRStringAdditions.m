//
//  NSString+JRStringAdditions.m
//  AH Plaza
//
//  Created by Casper Eekhof on 08-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "NSString+JRStringAdditions.h"

@implementation NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end
