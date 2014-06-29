//
//  LHScheduleCell.m
//  Lithouse
//
//  Created by Shah Hossain on 6/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHScheduleCell.h"

@implementation LHScheduleCell

- (IBAction) valueChanged : (id) sender
{
    if ( self.enableValueChangedCallback ) {
        self.enableValueChangedCallback ( self.enableSwitch.on );
    }
}

@end
