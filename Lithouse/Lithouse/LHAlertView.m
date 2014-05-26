//
//  UIAlertView+LHBlockAdditions.m
//  Lithouse
//
//  Created by Shah Hossain on 5/25/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHAlertView.h"

@interface LHAlertView () <UIAlertViewDelegate>

@end

@implementation LHAlertView


- (id) initWithTitle : (NSString *) title
             message : (NSString *) message
   cancelButtonTitle : (NSString *) cancelButtonTitle
   otherButtonTitles : (NSArray *) otherButtonTitles
{
    self = [self initWithTitle : title
                       message : message
                      delegate : self
             cancelButtonTitle : cancelButtonTitle
             otherButtonTitles : nil];
    
    if (self) {
        for (NSString * buttonTitle in otherButtonTitles) {
            [self addButtonWithTitle : buttonTitle];
        }
    }
    return self;
}


- (void)alertView : (UIAlertView *) alertView didDismissWithButtonIndex : (NSInteger) buttonIndex {
    
    if (self.completion) {
        self.completion ( buttonIndex == self.cancelButtonIndex, buttonIndex );
    }
}

@end