//
//  MenuViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 21-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "MenuViewController.h"
#import "PlanningViewController.h"
#import "IIViewDeckController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self showMenuImage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self animateTransition:^{}];
}


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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue destinationViewController] isKindOfClass: [AHViewController class]]) {
        AHViewController * vc = (AHViewController*) [segue destinationViewController];
        [vc setIsPushed: YES];
    }
}

@end
