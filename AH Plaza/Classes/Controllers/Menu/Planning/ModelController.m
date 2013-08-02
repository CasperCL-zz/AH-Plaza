//
//  ModelController.m
//  test
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "ModelController.h"

#import "PlanningViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController()
@end

@implementation ModelController

- (id)init
{
    self = [super init];
    if (self) {
        Week * week = [[Week alloc] init];
        
        NSArray *keys = [[NSArray alloc] initWithObjects:
                         @"monday",
                         @"tuesday",
                         @"wednesday",
                         @"thursday",
                         @"friday",
                         @"saturday",
                         @"sunday",
                         nil];
        
        NSArray * fromTillKeys = [[NSArray alloc] initWithObjects: @"from", @"till", nil];
        NSArray *dataTmp = [[NSArray alloc] initWithObjects:@"01:00", @"10:30", nil];
        NSDictionary *fromTill1 = [[NSDictionary alloc] initWithObjects: dataTmp forKeys: fromTillKeys];
        NSArray *dataTmp2 = [[NSArray alloc] initWithObjects:@"12:15", @"13:45", nil];
        NSDictionary *fromTill2 = [[NSDictionary alloc] initWithObjects: dataTmp2 forKeys: fromTillKeys];
        
        
        
        NSArray * objects = [[NSArray alloc] initWithObjects: fromTill1, fromTill2, fromTill2, fromTill2, fromTill2, fromTill2, fromTill2, nil];
        week.workingTimes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
        week.weekID = @"Week 31";
        _pageData = [[NSArray alloc] initWithObjects: week, nil];
    }
    return self;
}

- (PlanningViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PlanningViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlanningViewController"];
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(PlanningViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PlanningViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PlanningViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
