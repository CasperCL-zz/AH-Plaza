//
//  ModelController.h
//  test
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlanningViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (PlanningViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(PlanningViewController *)viewController;
@property NSArray *pageData;

@end
