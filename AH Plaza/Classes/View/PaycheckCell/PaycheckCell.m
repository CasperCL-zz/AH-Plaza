//
//  PaycheckCell.m
//  AH Plaza
//
//  Created by Casper Eekhof on 13-10-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "PaycheckCell.h"
#import "Fonts.h"
#import "Constants.h"

@implementation PaycheckCell

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [_periodLabel setFont: app_font_medium(19)];
        [_dateLabel setFont: app_font_medium(15)];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
