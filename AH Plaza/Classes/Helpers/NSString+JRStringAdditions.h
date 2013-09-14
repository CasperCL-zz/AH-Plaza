//
//  NSString+JRStringAdditions.h
//  AH Plaza
//
//  Created by Casper Eekhof on 08-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JRStringAdditions)

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;

@end
