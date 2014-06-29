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
        
        self.displayImage = [UIImage imageNamed : @"ic_switch"];
    }
    
    return self;
}
@end
