//
//  Popup.m
//  AH Plaza
//
//  Created by Casper Eekhof on 08-08-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "Popup.h"
#import <QuartzCore/QuartzCore.h>

@implementation Popup

- (id)initWithView: (UIView*) view
{
    self = [super init];
    if (self) {
        _displayView = view;
        CGRect popupFrame;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        popupFrame.size.height = screenRect.size.height;
        popupFrame.size.width = screenRect.size.width;
        popupFrame.origin.x = 0;
        popupFrame.origin.y = 0;
        
        CGRect backgroundFrame = screenRect;
        
        CGRect dialogFrame;
        dialogFrame.size.height = 90;
        dialogFrame.size.width = 280;
        dialogFrame.origin.x = (backgroundFrame.size.width / 2) - (dialogFrame.size.width / 2); // center the view
        dialogFrame.origin.y = (backgroundFrame.size.height / 2) - (dialogFrame.size.height / 2);
        
        _background = [[UIView alloc] initWithFrame: backgroundFrame];
        _dialog = [[UIView alloc] initWithFrame: dialogFrame];
        _popUpView = [[UIView alloc] initWithFrame: popupFrame];
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        
        // These frames should be made when the decision is made to use 1 or either 2 of the buttons or an activity indicator.
        _button1 = [[UIButton alloc] init];
        _button2 = [[UIButton alloc] init];
        _dialogLabel = [[UILabel alloc] init];
        [_dialogLabel setNumberOfLines: 0];
        [_dialogLabel setTextAlignment: NSTextAlignmentCenter];
        
        [_background setBackgroundColor: [UIColor blackColor]];
        _background.alpha = 0.7;
        _dialog.layer.cornerRadius = 10;
        _dialog.layer.masksToBounds = YES;
        [_dialog setBackgroundColor: [UIColor whiteColor]];
        
        [_popUpView addSubview: _background];
        [_popUpView addSubview: _dialog];
        [_displayView addSubview: _popUpView];
        [_popUpView setAlpha: 0.0f];
        [_popUpView setHidden: YES];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        if(self.displayView == nil)
            NSLog(@"WARNING: You do not have linked any view with this popup %@", self);
    }
    return self;
}


- (void) showPopupWithAnimationDuration:(float)duration {
    [UIView animateWithDuration: duration animations:^{
        [_popUpView setAlpha: 1.0f];
        [_popUpView setHidden: NO];
    }];
}

- (void) hidePopupWithAnimationDuration:(float) duration {
    [UIView animateWithDuration: duration animations:^{
        [_popUpView setAlpha: 0.0f];
    } completion:^(BOOL finished) {
        [_popUpView setHidden: YES];
    }];
}


- (void) showPopupWithAnimationDuration:(float) duration withText: (NSString*) text {
    [self removeDialogComponents];
    
        
    CGRect labelFrame;
    int paddingLeftRight = 10;
    int paddingTopBottom = 10;
    labelFrame.origin.x = paddingLeftRight/2;
    labelFrame.origin.y = paddingTopBottom/2;
    labelFrame.size.height = [_dialog frame].size.height - paddingTopBottom;
    labelFrame.size.width = [_dialog frame].size.width - paddingLeftRight;
    [_dialogLabel setFrame: labelFrame];
    [_dialogLabel setTextColor: [UIColor blackColor]];
    [_dialogLabel setBackgroundColor:[UIColor clearColor]];
    
    [_dialogLabel setText: text];
    [_dialog addSubview: _dialogLabel];
    
    [self showPopupWithAnimationDuration: duration];
}

- (void) showPopupWithAnimationDuration:(float) duration withActivityIndicatorAndText: (NSString*) text {
    [self removeDialogComponents];
    // The amount of taken space seen from the top of the dialog
    int spaceTakenFromTop = 0;
    
    CGRect aiFrame;
    int paddingTop = 15;
    aiFrame.size.height = 20;
    aiFrame.size.width = 20;
    aiFrame.origin.x = [_dialog frame].size.width/2 - aiFrame.size.width/2;
    aiFrame.origin.y = paddingTop;
    [_activityIndicator setFrame: aiFrame];
    [_activityIndicator startAnimating];
    spaceTakenFromTop += _activityIndicator.frame.origin.y + (aiFrame.size.height/2);
    
    CGRect labelFrame;
    int paddingLeftRight = 20;
    int paddingTopBottom = 10;
    labelFrame.origin.x = paddingLeftRight/2;
    labelFrame.origin.y = paddingTopBottom/2 + spaceTakenFromTop * 1.5;
    labelFrame.size.height = [_dialog frame].size.height - paddingTopBottom - spaceTakenFromTop*2;
    labelFrame.size.width = [_dialog frame].size.width - paddingLeftRight;
    [_dialogLabel setFrame: labelFrame];
    [_dialogLabel setTextColor: [UIColor blackColor]];
    [_dialogLabel setBackgroundColor:[UIColor clearColor]];
    
    [_dialogLabel setText: text];
    [_dialog addSubview: _dialogLabel];
    [_dialog addSubview: _activityIndicator];
        
    [self showPopupWithAnimationDuration: duration];
}

- (void) showPopupWithAnimationDuration:(float) duration withText: (NSString*) text withButtonText: (NSString*) buttonText withResult: (result) result {
    [self removeDialogComponents];
    
    _resultCallback = result;
    
    CGRect dialogFrame;
    dialogFrame.size.height = 150;
    dialogFrame.size.width = 280;
    dialogFrame.origin.x = (_background.frame.size.width / 2) - (dialogFrame.size.width / 2); // center the view
    dialogFrame.origin.y = (_background.frame.size.height / 2) - (dialogFrame.size.height / 2);
    [_dialog setFrame: dialogFrame];
    
    
    // The amount of taken space seen from the top of the dialog
    int spaceTaken = 0;
    
    
    CGRect labelFrame;
    int paddingLeftRight = 20;
    int paddingTopBottom = 10;
    labelFrame.origin.x = paddingLeftRight/2;
    labelFrame.origin.y = paddingTopBottom/2 + spaceTaken * 1.5;
    labelFrame.size.height = [_dialog frame].size.height/(double)(1.5) - paddingTopBottom;
    labelFrame.size.width = [_dialog frame].size.width - paddingLeftRight;
    [_dialogLabel setFrame: labelFrame];
    [_dialogLabel setTextColor: [UIColor blackColor]];
    [_dialogLabel setBackgroundColor:[UIColor clearColor]];
    [_dialogLabel setText: text];
    spaceTaken += paddingTopBottom + _dialogLabel.frame.size.height;
    
    CGRect button1Frame;
    button1Frame.size.height = 35;
    button1Frame.size.width = [_dialog frame].size.width - paddingLeftRight;
    button1Frame.origin.x = [_dialog frame].size.width/2 - button1Frame.size.width/2; // center the view
    button1Frame.origin.y = spaceTaken;
    [_button1 setFrame: button1Frame];
    [_button1 setBackgroundColor: [UIColor blackColor]];
    [_button1 setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [_button1 setTitleColor: [UIColor grayColor] forState: UIControlStateHighlighted];

    [_button1 setTitle: buttonText forState: UIControlStateNormal];
    [_button1 setTitle: buttonText forState: UIControlStateHighlighted];
    _button1.layer.cornerRadius = 10;
    _button1.layer.masksToBounds = YES;
    
    [_button1 addTarget: self action:@selector(button1Tapped) forControlEvents: UIControlEventTouchUpInside];
    
    [_dialog addSubview: _dialogLabel];
    [_dialog addSubview: _button1];
    
    
    [self showPopupWithAnimationDuration: duration];
}

- (void) showPopupWithAnimationDuration:(float) duration withText: (NSString*) text withButton1Text: (NSString*) button1Text withButton2Text: (NSString*) button2Text withResult: (result) result {
    [self removeDialogComponents];
    
    _resultCallback = result;
    
    CGRect dialogFrame;
    dialogFrame.size.height = 150;
    dialogFrame.size.width = 280;
    dialogFrame.origin.x = (_background.frame.size.width / 2) - (dialogFrame.size.width / 2); // center the view
    dialogFrame.origin.y = (_background.frame.size.height / 2) - (dialogFrame.size.height / 2);
    [_dialog setFrame: dialogFrame];
    
    
    // The amount of taken space seen from the top of the dialog
    int spaceTaken = 0;
    
    
    CGRect labelFrame;
    int paddingLeftRight = 20;
    int paddingTopBottom = 10;
    labelFrame.origin.x = paddingLeftRight/2;
    labelFrame.origin.y = paddingTopBottom/2 + spaceTaken * 1.5;
    labelFrame.size.height = [_dialog frame].size.height/(double)(1.5) - paddingTopBottom;
    labelFrame.size.width = [_dialog frame].size.width - paddingLeftRight;
    [_dialogLabel setFrame: labelFrame];
    [_dialogLabel setTextColor: [UIColor blackColor]];
    [_dialogLabel setBackgroundColor:[UIColor clearColor]];
    [_dialogLabel setText: text];
    spaceTaken += paddingTopBottom + _dialogLabel.frame.size.height;
    
    CGRect button1Frame;
    button1Frame.size.height = 35;
    button1Frame.size.width = [_dialog frame].size.width/2 - paddingLeftRight;
    button1Frame.origin.x = [_dialog frame].size.width/4 - button1Frame.size.width/2; // center the view
    button1Frame.origin.y = spaceTaken;
    [_button1 setFrame: button1Frame];
    [_button1 setBackgroundColor: [UIColor blackColor]];
    [_button1 setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [_button1 setTitleColor: [UIColor grayColor] forState: UIControlStateHighlighted];
    
    [_button1 setTitle: button1Text forState: UIControlStateNormal];
    [_button1 setTitle: button1Text forState: UIControlStateHighlighted];
    _button1.layer.cornerRadius = 10;
    _button1.layer.masksToBounds = YES;
    
    CGRect button2Frame;
    button2Frame.size.height = 35;
    button2Frame.size.width = [_dialog frame].size.width/2 - paddingLeftRight;
    button2Frame.origin.x = ([_dialog frame].size.width/4)*3 - button2Frame.size.width/2; // center the view
    button2Frame.origin.y = _button1.frame.origin.y;
    [_button2 setFrame: button2Frame];
    [_button2 setBackgroundColor: [UIColor blackColor]];
    [_button2 setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [_button2 setTitleColor: [UIColor grayColor] forState: UIControlStateHighlighted];
    
    [_button2 setTitle: button2Text forState: UIControlStateNormal];
    [_button2 setTitle: button2Text forState: UIControlStateHighlighted];
    _button2.layer.cornerRadius = 10;
    _button2.layer.masksToBounds = YES;    
    
    
    [_button1 addTarget: self action:@selector(button1Tapped) forControlEvents: UIControlEventTouchUpInside];
    [_button2 addTarget: self action:@selector(button2Tapped) forControlEvents: UIControlEventTouchUpInside];
    
    [_dialog addSubview: _dialogLabel];
    [_dialog addSubview: _button1];
    [_dialog addSubview: _button2];

    [self showPopupWithAnimationDuration: duration];
}

-(void) removeDialogComponents {
    for (UIView *view in [_dialog subviews]) {
        [view removeFromSuperview];
    }
}

- (void) button1Tapped {
    [self hidePopupWithAnimationDuration: 1.0];
    _resultCallback(OKAY);
}

- (void) button2Tapped {
    [self hidePopupWithAnimationDuration: 1.0];
    _resultCallback(CANCELED);
}

@end
