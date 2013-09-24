//
//  AHNavigationController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 21-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "AHNavigationController.h"

@interface AHNavigationController ()

@end

@implementation AHNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customizeNavBar];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customizeNavBar];
    }
    return self;
}

-(void) customizeNavBar {
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor whiteColor];
    //    self.navigationController.navigationBar.backItem.backBarButtonItem.
    
    self.navigationBar.titleTextAttributes = @{
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
       } forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
