//
//  LHGarageDoor.m
//  Lithouse
//
//  Created by Shah Hossain on 6/24/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHGarageDoor.h"
#import "LHAction.h"
#import <HomeKit/HomeKit.h>

@implementation LHGarageDoor

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
                              inHome:(HMHome *) home
{
    if ( self = [super initWithHMAccessory:accessory
                    withPrimaryServiceType:HMServiceTypeGarageDoorOpener
                    withCharacteristicType:HMCharacteristicTypeLocked
withActionIdForSettingPrimaryCharacteristic:LHLockActionId
withActionIdForUnsettingPrimaryCharacteristic:LHUnlockActionId
                                    inHome:home] ) {
    }
    
    return self;
}

//todo: may need to change HMCharacteristicTypeTargetDoorState before locking

- (UIImage *) imageForStatus : (LHDeviceStatus) status
{
    return [LHGarageDoor imageForStatus:status];
}

+ (UIImage *) imageForStatus : (LHDeviceStatus) status
{
    static dispatch_once_t pred;
    static NSDictionary * imageDictionary = nil;
    
    dispatch_once(&pred, ^{
        imageDictionary = @{@(LHDeviceIsOn):[UIImage imageNamed:@"garage_closed"],
                            @(LHDeviceIsOff):[UIImage imageNamed:@"garage_open"]};
    });
    
    UIImage * imageForStatus = [imageDictionary objectForKey:@(status)];
    return ((imageForStatus == nil) ?
            [imageDictionary objectForKey:@(LHDeviceIsOff)]:imageForStatus);
}

- (NSString *) defaultActionId
{
    return LHLockActionId;
}


@end
