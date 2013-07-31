//
//  MenuViewController.h
//  AH Plaza
//
//  Created by Casper Eekhof on 21-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *componentsView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsLeftSide;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsRightSide;
- (IBAction)showPlanning:(id)sender;

@end
