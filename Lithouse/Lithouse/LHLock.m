//
//  LHLock.m
//  Lithouse
//
//  Created by Shah Hossain on 6/23/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHLock.h"
#import "LHAction.h"
#import <HomeKit/HomeKit.h>

@implementation LHLock

//todo: cleanup garage door and lock set/unset logic
- (instancetype) initWithHMAccessory:(HMAccessory *) accessory inHome:(HMHome *) home
{
    self = [super initWithHMAccessory:accessory
               withPrimaryServiceType:HMServiceTypeLock
  withPrimaryTargetCharacteristicType:HMCharacteristicTypeLocked
 withPrimaryCurrentCharacteristicType:HMCharacteristicTypeLocked
withActionIdForSettingPrimaryCharacteristic:LHUnlockActionId
withActionIdForUnsettingPrimaryCharacteristic:LHLockActionId
 withPrimPrimaryCharacteristicValueOn:@(0)
withPrimPrimaryCharacteristicValueOff:@(1)
                               inHome:home];
    
    return self;
}


- (UIImage *) imageForStatus : (LHDeviceStatus) status
{
    return [LHLock imageForStatus:status];
}


+ (UIImage *) imageForStatus : (LHDeviceStatus) status
{
    static dispatch_once_t pred;
    static NSDictionary * imageDictionary = nil;
    
    dispatch_once(&pred, ^{
        imageDictionary = @{@(LHDeviceIsOn):[UIImage imageNamed:@"unlocked"],
                            @(LHDeviceIsOff):[UIImage imageNamed:@"locked"]};
    });
    
    UIImage * imageForStatus = [imageDictionary objectForKey:@(status)];
    //todo: create a new icon for unknown lock status
    return [((imageForStatus == nil) ?
             [imageDictionary objectForKey:@(LHDeviceIsOn)]:imageForStatus)
            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}


- (NSString *) defaultActionId
{
    return LHLockActionId;
}


@end
