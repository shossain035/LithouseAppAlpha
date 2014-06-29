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
                              inHome:(HMHome *) home
{
    if ( self = [super initWithHMAccessory:accessory
                    withPrimaryServiceType:HMServiceTypeLightbulb
                    withCharacteristicType:HMCharacteristicTypePowerState
withActionIdForSettingPrimaryCharacteristic:LHTurnOnActionId
withActionIdForUnsettingPrimaryCharacteristic:LHTurnOffActionId
                                    inHome:home] ) {
        
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
    CGFloat hue, saturation, brightness, alpha;
    
    [toColor getHue:&hue
         saturation:&saturation
         brightness:&brightness
              alpha:&alpha];
    
    [self writeTargetValue:@(hue) fromCurrentRangeMin:@(0) fromCurrentRangeMax:@(1) toCharacteristic:self.hue];
    [self writeTargetValue:@(saturation) fromCurrentRangeMin:@(0) fromCurrentRangeMax:@(1) toCharacteristic:self.saturation];
    [self writeTargetValue:@(brightness) fromCurrentRangeMin:@(0) fromCurrentRangeMax:@(1) toCharacteristic:self.brightness];
    
    //ignore alpha
}

- (UIColor *) getCurrentColor;
{
    return [[UIColor alloc] initWithHue:[self convertValueOfCharacteristic:self.hue toTargetRangeMin:@(0) toTargetRangeMax:@(1)].floatValue
                             saturation:[self convertValueOfCharacteristic:self.saturation toTargetRangeMin:@(0) toTargetRangeMax:@(1)].floatValue
                             brightness:[self convertValueOfCharacteristic:self.brightness toTargetRangeMin:@(0) toTargetRangeMax:@(1)].floatValue
                                  alpha:1.0];
}

- (BOOL) doesSupportColorControl
{
    //todo: break it up
    return (self.hue != nil && self.saturation != nil && self.brightness != nil);
}

@end
