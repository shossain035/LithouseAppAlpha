//
//  LHDeviceCell.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDeviceCell.h"

@implementation LHDeviceCell

- (id) initWithCoder : (NSCoder*) aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor greenColor] CGColor];
        self.layer.cornerRadius = 10;
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect : self.bounds
                                                            cornerRadius : self.layer.cornerRadius] CGPath];
    }
    return self;
}

- (IBAction) infoButtonTapped : (id) sender
{
    NSLog ( @"info button tapped" );
    self.infoButtonCallback();
}


@end
