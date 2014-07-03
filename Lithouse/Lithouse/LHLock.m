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

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory inHome:(HMHome *) home
{
    if ( self = [super initWithHMAccessory:accessory
                    withPrimaryServiceType:HMServiceTypeLock
                    withCharacteristicType:HMCharacteristicTypeLocked
withActionIdForSettingPrimaryCharacteristic:LHLockActionId
withActionIdForUnsettingPrimaryCharacteristic:LHUnlockActionId
                                    inHome:home] ) {
        
        self.displayImage = [UIImage imageNamed : @"lock_closed"];
    }
    
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
        imageDictionary = @{@(LHDeviceIsOn):[UIImage imageNamed : @"lock_closed"],
                            @(LHDeviceIsOff):[UIImage imageNamed : @"lock_open"]};
    });
    
    return [imageDictionary objectForKey:@(status)];
}


- (NSString *) defaultActionId
{
    return LHLockActionId;
}


@end
