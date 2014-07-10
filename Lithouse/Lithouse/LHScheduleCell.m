//
//  LHScheduleCell.m
//  Lithouse
//
//  Created by Shah Hossain on 6/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHScheduleCell.h"

@interface LHScheduleCell ()
@property (strong, nonatomic) IBOutlet UIButton      * infoButton;
@end

@implementation LHScheduleCell

- (void) activate : (BOOL) isActive
{
    if ( isActive ) {
        self.backgroundColor = [UIColor whiteColor];
        [self colorItemsWithColor:[UIColor blackColor]];
        self.infoButton.enabled = true;
    } else {
        self.backgroundColor = [UIColor lightGrayColor];
        [self colorItemsWithColor:[UIColor darkGrayColor]];
        self.infoButton.enabled = false;
    }
}

- (void) colorItemsWithColor:(UIColor *) color
{
    self.timeHourMinuteLabel.textColor = color;
    self.timeAMPMLabel.textColor = color;
    self.recurranceLabel.textColor = color;
    self.actionLabel.textColor = color;
}

@end
