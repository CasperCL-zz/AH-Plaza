//
//  UIImage+Tint.m
//  AH Plaza
//
//  Created by Casper Eekhof on 24-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "UIImage+Tint.h"

@implementation UIImage (Tint)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
