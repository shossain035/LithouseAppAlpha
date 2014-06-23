//
//  LHHomeKitBulb.m
//  Lithouse
//
//  Created by Shah Hossain on 6/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitBulb.h"
#import "LHAction.h"
#import <HomeKit/HomeKit.h>

@interface LHHomeKitBulb ()
@property (nonatomic, strong, readonly) HMCharacteristic * hue;
@property (nonatomic, strong, readonly) HMCharacteristic * saturation;
@property (nonatomic, strong, readonly) HMCharacteristic * brightness;

@end

@implementation LHHomeKitBulb

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
{
    if ( self = [super initWithHMAccessory:accessory
                    withPrimaryServiceType:HMServiceTypeLightbulb
                    withCharacteristicType:HMCharacteristicTypePowerState
withActionIdForSettingPrimaryCharacteristic:LHTurnOnActionId
withActionIdForUnsettingPrimaryCharacteristic:LHTurnOffActionId] ) {
        
        self.displayImage = [UIImage imageNamed : @"hue"];
        
        _hue = [self characteristicWithType:HMCharacteristicTypeHue forService:self.primaryService];
        _saturation = [self characteristicWithType:HMCharacteristicTypeSaturation forService:self.primaryService];
        _brightness = [self characteristicWithType:HMCharacteristicTypeBrightness forService:self.primaryService];
        
    }
    
    return self;
}

#pragma mark ColoredLight
- (void) updateColor : (UIColor *) toColor
{
}

- (UIColor *) getCurrentColor;
{
    return nil;
}

- (BOOL) doesSupportColorControl
{
    //todo: break it up
    return (self.hue != nil && self.saturation != nil && self.brightness != nil);
}

@end
