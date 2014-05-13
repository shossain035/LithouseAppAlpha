//
//  LHWeMoSwitch.m
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHWeMoSwitch.h"

@implementation LHWeMoSwitch

- (id) init
{
    if ( self = [super init] ) {
        [self.permissibleActions addObject : [[LHTurnOn alloc] initWithParentDevice : self]];
        [self.permissibleActions addObject : [[LHTurnOff alloc] initWithParentDevice : self]];
    }
    
    return self;
}


- (void) turnOn
{
    NSLog ( @"turning wemo on");
}

- (void) turnOff
{
    NSLog ( @"turning wemo off");
}


@end
