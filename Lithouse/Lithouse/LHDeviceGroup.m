//
//  LHDeviceGroup.m
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDeviceGroup.h"

@implementation LHDeviceGroup

- (id) initWithManagedDeviceGroup : (DeviceGroup *) aManagedDeviceGroup
{
    if ( self = [super init] ) {
        self.managedDeviceGroup = aManagedDeviceGroup;
        self.friendlyName = aManagedDeviceGroup.name;
        //self.displayImage =
        //self.permessible
    }

    return self;
}

- (void) toggle
{
    NSLog ( @"Toggling device group" );
}


@end
