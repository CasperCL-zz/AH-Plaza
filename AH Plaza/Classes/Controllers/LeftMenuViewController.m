//
//  LeftMenuViewController.m
//  AH Plaza
//
//  Created by Casper Eekhof on 15-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "String.h"
#import "Constants.h"
#import "IIViewDeckController.h"
#import "AHViewController.h"
#import "AHNavigationController.h"
#import "Fonts.h"

@interface LeftMenuViewController ()

@end

typedef enum {
    MENU_MENU_ITEM = 0,
    PAYMENTDAYS_MENU_ITEM,
    PLANNING_MENU_ITEM,
    PAYCECK_MENU_ITEM,
    SETTINGS_MENU_ITEM
} LEFT_MENU_ITEM;

@implementation LeftMenuViewController

NSArray * sections;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sections = @[@""];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        sections = @[@""];
    }
    return self;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sections count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    AHViewController * viewController;
    switch ([indexPath item]) {
        case MENU_MENU_ITEM:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
            break;
        case PLANNING_MENU_ITEM:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
            break;
        case PAYMENTDAYS_MENU_ITEM:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"PaymentsDaysViewController"];
            break;
        case PAYCECK_MENU_ITEM:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"PayCheckViewController"];
            break;
        case SETTINGS_MENU_ITEM:
            viewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            break;
    }
    [viewController setIsPushed: NO];
    AHNavigationController * bar = [[AHNavigationController alloc] initWithRootViewController: viewController];
    
    self.viewDeckController.centerController = bar;
    [self.viewDeckController toggleLeftView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    
    [cell.textLabel setText: [left_menu_items objectAtIndex: [indexPath item]]];
    [cell.textLabel setTextColor: UIColorFromRGB(ah_blue)];
    [cell.textLabel setFont: app_font(20)];
    
    UIView * border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    [border setBackgroundColor: [UIColor lightGrayColor]];
    [cell addSubview: border];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 300, 15)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.text= [sections objectAtIndex: section];
    [tempLabel setTextColor: UIColorFromRGB(ah_blue)];
    [tempLabel setFont: app_font_medium(20)];
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [left_menu_items count];
}

@end
