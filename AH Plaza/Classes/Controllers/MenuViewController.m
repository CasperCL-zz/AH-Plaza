//
//  MenuViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 21-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "MenuViewController.h"
#import "PlanningView.h"
#import "PlanningViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self animateTransition:^{
//        [self settleIconsAndShowLabels];
    }];
    [self customizeNavBar];
}

//- (void) viewDidAppear:(BOOL)animated {
//    [self settleIconsAndShowLabels];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Normally the OS would do this, but it is buggy so we have to do this manualy from this UIViewController.
- (void)animateTransition:  (void (^)(void)) completion {
    _componentsView.alpha = 0.0f;
    
    [UIView animateWithDuration: 1.0 animations:^{
        _componentsView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)viewDidUnload {
    [self setView:nil];
    [self setComponentsView:nil];
    [self setButtonsLeftSide:nil];
    [self setButtonsRightSide:nil];
    [super viewDidUnload];
}


- (void )settleIconsAndShowLabels {
    float delay = 0.4f;
    
    if(((UIView*)[_buttonsRightSide objectAtIndex: 0]).frame.origin.x != 0) { // view did load
        NSMutableArray *newFrames = [[NSMutableArray alloc] init];
//        int lcount = 0;
        for (UIView *view in _buttonsLeftSide) {
            CGRect frame = view.frame;
            frame.origin.x -= 20;
//            if(!lcount)
//                frame.origin.y += 20;
            
            [newFrames addObject: [NSValue valueWithCGRect: frame]];
//            lcount++;
        }
        [UIView animateWithDuration: delay animations:^{
            int count = 0;
            for (UIView *view in _buttonsLeftSide) {
                view.frame = [[newFrames objectAtIndex: count] CGRectValue];
                count++;
            }
        }];
        
        [newFrames removeAllObjects];
//        lcount = 0;
        for (UIView *view in _buttonsRightSide) {
            CGRect frame = view.frame;
            frame.origin.x += 20;
//            if(!lcount)
//                frame.origin.y += 20;
            
            [newFrames addObject: [NSValue valueWithCGRect: frame]];
//            lcount++;
            
        }
        [UIView animateWithDuration: delay animations:^{
            int count = 0;
            for (UIView *view in _buttonsRightSide) {
                view.frame = [[newFrames objectAtIndex: count] CGRectValue];
                count++;
            }
        }];
    }
}


// User functions
- (void) customizeNavBar {
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.navigationController.navigationBar.backItem.backBarButtonItem.
    
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    UITextAttributeTextColor: [UIColor blackColor],
                                                                    UITextAttributeTextShadowColor: [UIColor whiteColor],
                                                                    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                                                    UITextAttributeFont: [UIFont fontWithName:@"STHeitiTC-Light" size:20.0f]
                                                                    };
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{UITextAttributeTextColor:[UIColor blackColor],
                                                                     UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                                      UITextAttributeTextShadowColor:[UIColor whiteColor],
                                                                                 UITextAttributeFont:[UIFont fontWithName:@"STHeitiTC-Light" size:12.0]
     }
                                                                                            forState:UIControlStateNormal];
}


- (IBAction)showPlanning:(id)sender {
    PlanningViewController *vc = [[PlanningViewController alloc] init];
    PlanningView *planningView = [[[NSBundle mainBundle] loadNibNamed:@"PlanningView" owner: vc options:nil] objectAtIndex: 0];
    vc.view = planningView;
    
    [vc setPlanningView: planningView];
    [self.navigationController pushViewController: vc animated: YES];
}
@end
