//
//  LHHomeKitDeviceFactory.m
//  Lithouse
//
//  Created by Shah Hossain on 6/21/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitDeviceFactory.h"
#import "LHHomeKitDevice.h"
#import "LHHomeKitBulb.h"
#import "LHLock.h"
#import "LHSwitch.h"
#import "LHGarageDoor.h"
#import <HomeKit/HomeKit.h>

@implementation LHHomeKitDeviceFactory

+ (LHDevice *) newHomeKitDeviceWithAccessory : (HMAccessory *) accessory
                                       inHome:(HMHome *) home;
{
    for (HMService * service in accessory.services) {
        NSLog(@"service: %@", service.serviceType);
        if ( [service.serviceType isEqualToString:HMServiceTypeLightbulb] ) {
            return [[LHHomeKitBulb alloc] initWithHMAccessory:accessory inHome:home];
        } else if ( [service.serviceType isEqualToString:HMServiceTypeLock] ) {
            return [[LHLock alloc] initWithHMAccessory:accessory inHome:home];
        } else if ( [service.serviceType isEqualToString:HMServiceTypeSwitch] ) {
            return [[LHSwitch alloc] initWithHMAccessory:accessory inHome:home];
        } else if ( [service.serviceType isEqualToString:HMServiceTypeGarageDoorOpener] ) {
            return [[LHGarageDoor alloc] initWithHMAccessory:accessory inHome:home];
        }
    }
        
    return [[LHHomeKitDevice alloc] initWithHMAccessory:accessory inHome:home];
}


@end
