//
//  AHViewController.h
//  AH Plaza
//
//  Created by Casper Eekhof on 21-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHViewController : UIViewController


@property (nonatomic) BOOL isPushed;
- (void) pop;
- (void) showBackImage;
- (void) showMenuImage;

@end
