//
//  LHThermostat.m
//  Lithouse
//
//  Created by Shah Hossain on 7/2/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHThermostat.h"
#import "LHAction.h"
#import <HomeKit/HomeKit.h>

@interface LHThermostat ()
@property (nonatomic, strong) HMCharacteristic * currentTemperature;
@property (nonatomic, strong) HMCharacteristic * targetTemperature;
@end

@implementation LHThermostat

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory inHome:(HMHome *) home
{
    if ( self = [super initWithHMAccessory:accessory
                    withPrimaryServiceType:HMServiceTypeThermostat
       withPrimaryTargetCharacteristicType:HMCharacteristicTypeTargetHeatingCooling
      withPrimaryCurrentCharacteristicType:HMCharacteristicTypeCurrentHeatingCooling
withActionIdForSettingPrimaryCharacteristic:LHTurnOnActionId
withActionIdForUnsettingPrimaryCharacteristic:LHTurnOffActionId
      withPrimPrimaryCharacteristicValueOn:HMCharacteristicValueHeatingCoolingAuto
     withPrimPrimaryCharacteristicValueOff:HMCharacteristicValueHeatingCoolingOff
                                    inHome:home] ) {
        
        _currentTemperature = [self characteristicWithType:HMCharacteristicTypeCurrentTemperature
                                                forService:self.primaryService];
        
        _targetTemperature = [self characteristicWithType:HMCharacteristicTypeTargetTemperature
                                               forService:self.primaryService];
       
        //reading all the necessary characteristics
        //todo: enable notification
//        [self getCurrentState];
//        [self getTargetState];
//        [self getCurrentTemperature];
//        [self getTargetTemperature];
//        
    }
    
    return self;
}

- (void) updateTargetTemperature:(NSNumber *) targetTemperature
{
    if ( [self getTargetState] != LHThermostatAuto ) {
        [self updateTargetState:LHThermostatAuto];
    }
    
    [self writeTargetValue:targetTemperature
          toCharacteristic:self.targetTemperature
     withCompletionHandler:nil];
}

- (NSNumber *) getTargetTemperature
{
    //ignoring completion handler. note: return value will be updated in next call
    [self readCharacteristic:self.targetTemperature withCompletionHandler:nil];
    
    return self.targetTemperature.value;
}

- (NSNumber *) getCurrentTemperature
{
    [self readCharacteristic:self.currentTemperature withCompletionHandler:nil];
    
    return self.currentTemperature.value;
}

- (LHCharacteristicRange) getTemperatureRange
{
    HMCharacteristicMetadata * metadata = self.targetTemperature.metadata;
    return LHMakeRange([metadata.minimumValue doubleValue],
                       [metadata.maximumValue doubleValue]);
}

- (void) updateTargetState:(LHThermostatState) targetState
{
    NSString * targetStateString = HMCharacteristicValueHeatingCoolingAuto;
    
    switch (targetState) {
        case LHThermostatHeating:
            targetStateString = HMCharacteristicValueHeatingCoolingHeat;
            break;
        case LHThermostatCooling:
            targetStateString = HMCharacteristicValueHeatingCoolingCool;
            break;
        case LHThermostatOff:
            targetStateString = HMCharacteristicValueHeatingCoolingOff;
            break;
        default:
            targetStateString = HMCharacteristicValueHeatingCoolingAuto;
            break;
    }
    
    [self writePrimaryTargetCharacteristic:targetStateString];
}

- (LHThermostatState) getTargetState
{
    [self readCharacteristic:self.primaryTargetCharacteristic withCompletionHandler:nil];
    return [self convertHMThermostatStateToLHState:self.primaryTargetCharacteristic.value];
}
         
- (LHThermostatState) getCurrentState
{
    [self readPrimaryCurrentCharacteristic];
    
    return [self convertHMThermostatStateToLHState:self.primaryCurrentCharacteristic.value];
}

- (LHThermostatState) convertHMThermostatStateToLHState:(NSString *) stateString
{
    if ( [stateString isEqualToString:HMCharacteristicValueHeatingCoolingHeat] ) {
        return LHThermostatHeating;
    } else if ( [stateString isEqualToString:HMCharacteristicValueHeatingCoolingCool] ) {
        return LHThermostatCooling;
    } if ( [stateString isEqualToString:HMCharacteristicValueHeatingCoolingAuto] ) {
        return LHThermostatAuto;
    }
    
    return LHThermostatOff;
}

- (void) readPrimaryCurrentCharacteristic
{
    [self readCharacteristic:self.primaryCurrentCharacteristic
       withCompletionHandler:^(id value) {
           if ( [value isEqual:HMCharacteristicValueHeatingCoolingAuto]
               || [value isEqual:HMCharacteristicValueHeatingCoolingHeat]
               || [value isEqual:HMCharacteristicValueHeatingCoolingCool] ) {
               self.currentStatus = LHDeviceIsOn;
           } else {
               self.currentStatus = LHDeviceIsOff;
           }
       }];
}

- (UIImage *) imageForStatus : (LHDeviceStatus) status
{
    return [LHThermostat imageForStatus:status];
}

+ (UIImage *) imageForStatus : (LHDeviceStatus) status
{
    static dispatch_once_t pred;
    static NSDictionary * imageDictionary = nil;
    
    dispatch_once(&pred, ^{
        imageDictionary = @{@(LHDeviceIsOn):[UIImage imageNamed:@"thermostat_on"],
                            @(LHDeviceIsOff):[UIImage imageNamed:@"thermostat_off"]};
    });
    
    UIImage * imageForStatus = [imageDictionary objectForKey:@(status)];
    return ((imageForStatus == nil) ?
            [imageDictionary objectForKey:@(LHDeviceIsOff)]:imageForStatus);
}

@end
