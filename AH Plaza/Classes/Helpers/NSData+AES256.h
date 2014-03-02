//
//  NSData+AES256.h
//  AH Plaza
//
//  Created by Casper Eekhof on 11-08-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
