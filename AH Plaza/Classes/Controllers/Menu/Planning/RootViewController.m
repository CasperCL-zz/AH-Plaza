//
//  RootViewController.m
//  test
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "RootViewController.h"

#import "ModelController.h"

#import "PlanningViewController.h"

#import "WebHelper.h"

#import "Popup.h"

#import "Constants.h"

@interface RootViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;
@end

@implementation RootViewController

@synthesize modelController = _modelController;
static NSArray *_weeks;
Popup * popup;
int monthCount;
NSTimer * timer;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    [_monthLabel setTextColor: UIColorFromRGB(ah_blue)];
    monthCount = -1;
    timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(changeMonth:) userInfo:nil repeats:YES];
    [timer fire];
    
    UIImage *buttonImage = [UIImage imageNamed:@"refresh"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refreshPlanning) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = customBarItem;

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    // Download the data and fill the data
    if (!_weeks)
        [self refreshPlanning];
    else {
        [self.modelController setPageData: _weeks];
        PlanningViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
        
        self.pageViewController.dataSource = self.modelController;
        
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        CGRect pageViewRect = self.view.bounds;
        self.pageViewController.view.frame = pageViewRect;
        
        [self.pageViewController didMoveToParentViewController:self];
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
        
        // Hide the dialog
        [_dialogView setHidden: YES];
    }
}

- (void) changeMonth:(NSTimer*) timer {
    monthCount++;
    [UIView animateWithDuration:1.0f animations:^{
        _monthLabel.alpha = 0.0;
        _planningImage.alpha = 0.0;
        switch (monthCount) {
            case 0:
                [_monthLabel setText:@"Januari"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-1"]];
                break;
            case 1:
                [_monthLabel setText:@"Februari"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-feb"]];
                break;
            case 2:
                [_monthLabel setText:@"Maart"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-2"]];
                break;
            case 3:
                [_monthLabel setText:@"April"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-3"]];
                break;
            case 4:
                [_monthLabel setText:@"Mei"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-1"]];
                break;
            case 5:
                [_monthLabel setText:@"Juni"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-2"]];
                break;
            case 6:
                [_monthLabel setText:@"Juli"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-3"]];
                break;
            case 7:
                [_monthLabel setText:@"Augustus"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-1"]];
                break;
            case 8:
                [_monthLabel setText:@"September"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-2"]];
                break;
            case 9:
                [_monthLabel setText:@"Oktober"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-3"]];
                break;
            case 10:
                [_monthLabel setText:@"November"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-1"]];
                break;
            case 11:
                [_monthLabel setText:@"December"];
                [_planningImage setImage: [UIImage imageNamed:@"planning-2"]];
                monthCount = -1;
                break;
        }
        _monthLabel.alpha = 1.0;
        _planningImage.alpha = 1.0;
    } completion:^(BOOL finished) {
        [timer fire];
    }];
}

-(void) refreshPlanning {
    [[WebHelper sharedInstance] loadTimetablePage:^(NSArray *weeks) {
        [timer invalidate];
        [self.modelController setPageData: weeks];
        _weeks = weeks;
        PlanningViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
        
        self.pageViewController.dataSource = self.modelController;
        
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        CGRect pageViewRect = self.view.bounds;
        self.pageViewController.view.frame = pageViewRect;
        
        [self.pageViewController didMoveToParentViewController:self];
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
        
        // Hide the dialog
        [_dialogView setHidden: YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ModelController *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        
        _modelController = [[ModelController alloc] init];
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

/*
 - (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
 {
 
 }
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

- (void)viewDidUnload {
    [self setDialogView:nil];
    [super viewDidUnload];
}
@end
