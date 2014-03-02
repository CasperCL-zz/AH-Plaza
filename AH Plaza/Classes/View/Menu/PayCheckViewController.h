//
//  PayCheckViewController.h
//  AH Plaza Unofficial
//
//  Created by Casper Eekhof on 31-07-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AHViewController.h"

@interface PayCheckViewController : AHViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
