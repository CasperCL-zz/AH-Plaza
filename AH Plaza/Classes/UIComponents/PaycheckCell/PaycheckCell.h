//
//  PaycheckCell.h
//  AH Plaza
//
//  Created by Casper Eekhof on 13-10-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaycheckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *natureImageView;
@property (weak)  IBOutlet UILabel *periodLabel;
@property (weak)  IBOutlet UILabel *dateLabel;

@end
