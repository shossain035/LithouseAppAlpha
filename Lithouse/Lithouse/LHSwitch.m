//
//  LHSwitch.m
//  Lithouse
//
//  Created by Shah Hossain on 6/24/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHSwitch.h"
#import "LHAction.h"
#import <HomeKit/HomeKit.h>

@implementation LHSwitch
- (instancetype) initWithHMAccessory:(HMAccessory *) accessory inHome:(HMHome *) home
{
    if ( self = [super initWithHMAccessory:accessory
                    withPrimaryServiceType:HMServiceTypeSwitch
                    withCharacteristicType:HMCharacteristicTypePowerState
withActionIdForSettingPrimaryCharacteristic:LHTurnOnActionId
withActionIdForUnsettingPrimaryCharacteristic:LHTurnOffActionId
                                    inHome:home] ) {
        
    }
    
    return self;
}

- (UIImage *) imageForStatus : (LHDeviceStatus) status
{
    return [LHSwitch imageForStatus:status];
}

+ (UIImage *) imageForStatus : (LHDeviceStatus) status
{
    static dispatch_once_t pred;
    static NSDictionary * imageDictionary = nil;
    
    dispatch_once(&pred, ^{
        imageDictionary = @{@(LHDeviceIsOn):[UIImage imageNamed:@"switch_on"],
                            @(LHDeviceIsOff):[UIImage imageNamed:@"switch_off"]};
    });
    
    UIImage * imageForStatus = [imageDictionary objectForKey:@(status)];
    return [((imageForStatus == nil) ?
            [imageDictionary objectForKey:@(LHDeviceIsOff)]:imageForStatus)
            imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
