//
//  AHViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 21-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "AHViewController.h"
#import "IIViewDeckController.h"

@interface AHViewController ()

@end

@implementation AHViewController

- (id)init
{
    self = [super init];
    if (self) {
        _isPushed = NO;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    UIView * overlay = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    [overlay setBackgroundColor: [UIColor whiteColor]];
    [self.view addSubview: overlay];
    [UIView animateWithDuration:.5 animations:^{
        overlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view sendSubviewToBack: overlay];
    }];
}

-(void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showBackImage {
    UIImage *buttonImage = [UIImage imageNamed:@"back-button"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 29, 21);
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
}

- (void) showMenuImage {
    UIImage *buttonImage = [UIImage imageNamed:@"menu-button"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 23, 19);
    [button addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
}

-(void) setIsPushed:(BOOL)isPushed {
    _isPushed = isPushed;

    if(_isPushed)
        [self showBackImage];
    else
        [self showMenuImage];
}

@end
