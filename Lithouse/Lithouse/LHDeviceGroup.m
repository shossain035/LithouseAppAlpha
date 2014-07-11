//
//  LHDeviceGroup.m
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDeviceGroup.h"
#import "DeviceGroup.h"
#import "LHAction.h"

@interface LHDeviceGroup()

@property NSMutableDictionary                                * deviceDictionary;

@end

@implementation LHDeviceGroup

- (id) initWithManagedDeviceGroup : (DeviceGroup *) aManagedDeviceGroup
             withDeviceDictionary : (NSMutableDictionary *) aDeviceDictionary
{
    if ( self = [super init] ) {
        self.managedDeviceGroup = aManagedDeviceGroup;
        self.friendlyName = aManagedDeviceGroup.name;
        self.deviceDictionary = aDeviceDictionary;
    }

    return self;
}

- (void) toggle
{
    NSLog ( @"Toggling device group" );
    
    for ( NSString * deviceId in self.managedDeviceGroup.actions ) {
        NSString * actionId = [self.managedDeviceGroup.actions objectForKey : deviceId];
        NSLog(@"device id: %@ action: %@", deviceId, actionId );
        
        LHDevice * device = [self.deviceDictionary objectForKey : deviceId];
        LHAction * action = [device actionForActionId : actionId];
        
        [action performAction];
    }
}

- (UIImage *) imageForStatus:(LHDeviceStatus)status
{
    return [UIImage imageWithData:self.managedDeviceGroup.image];
}

@end
