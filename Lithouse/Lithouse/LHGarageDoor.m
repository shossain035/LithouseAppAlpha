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
    self = [super initWithHMAccessory:accessory
               withPrimaryServiceType:HMServiceTypeGarageDoorOpener
  withPrimaryTargetCharacteristicType:HMCharacteristicTypeTargetDoorState
 withPrimaryCurrentCharacteristicType:HMCharacteristicTypeCurrentDoorState
withActionIdForSettingPrimaryCharacteristic:LHUnlockActionId
withActionIdForUnsettingPrimaryCharacteristic:LHLockActionId
 withPrimPrimaryCharacteristicValueOn:@(0)
withPrimPrimaryCharacteristicValueOff:@(1)
                               inHome:home];
    
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
        imageDictionary = @{@(LHDeviceIsOn):[UIImage imageNamed:@"garage_open"],
                            @(LHDeviceIsOff):[UIImage imageNamed:@"garage_closed"]};
    });
    
    UIImage * imageForStatus = [imageDictionary objectForKey:@(status)];
    //todo: create a new icon for unknown garage door status 
    return ((imageForStatus == nil) ?
            [imageDictionary objectForKey:@(LHDeviceIsOn)]:imageForStatus);
}

- (NSString *) defaultActionId
{
    return LHLockActionId;
}


@end
