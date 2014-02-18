//
//  RootViewController.h
//  test
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHViewController.h"

@interface RootViewController : AHViewController <UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) IBOutlet UIImageView *planningImage;

@end
