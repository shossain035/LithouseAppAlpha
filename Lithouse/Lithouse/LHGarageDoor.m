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
{
    if ( self = [super initWithHMAccessory:accessory
                    withPrimaryServiceType:HMServiceTypeGarageDoorOpener
                    withCharacteristicType:HMCharacteristicTypeLocked
withActionIdForSettingPrimaryCharacteristic:LHLockActionId
withActionIdForUnsettingPrimaryCharacteristic:LHUnlockActionId] ) {
        
        self.displayImage = [UIImage imageNamed : @"lock_closed"];
    }
    
    return self;
}

//todo: may need to change HMCharacteristicTypeTargetDoorState before locking

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
