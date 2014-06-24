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
#import <HomeKit/HomeKit.h>

@implementation LHHomeKitDeviceFactory

+ (LHDevice *) newHomeKitDeviceWithAccessory : (HMAccessory *) accessory
{
    for (HMService * service in accessory.services) {
        NSLog(@"service: %@", service.serviceType);
        if ( [service.serviceType isEqualToString:HMServiceTypeLightbulb] ) {
            return [[LHHomeKitBulb alloc] initWithHMAccessory:accessory];
        } else if ( [service.serviceType isEqualToString:HMServiceTypeLock] ) {
            return [[LHLock alloc] initWithHMAccessory:accessory];
        }
    }
        
    return [[LHHomeKitDevice alloc] initWithHMAccessory:accessory];
}


@end
