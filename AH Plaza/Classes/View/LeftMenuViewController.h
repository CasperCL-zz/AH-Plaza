//
//  LeftMenuViewController.h
//  AH Plaza
//
//  Created by Casper Eekhof on 15-09-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
