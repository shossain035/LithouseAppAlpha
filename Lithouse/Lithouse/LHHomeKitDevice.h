//
//  LHHomeKitDevice.h
//  Lithouse
//
//  Created by Shah Hossain on 6/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"

@class HMAccessory;
@class HMService;
@class HMCharacteristic;

@interface LHHomeKitDevice : LHDevice

@property (nonatomic, strong, readonly) HMAccessory        * accessory;
@property (nonatomic, strong, readonly) HMService          * primaryService;

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory;
- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
              withPrimaryServiceType:(NSString *) serviceType
              withCharacteristicType:(NSString *) characteristicType
withActionIdForSettingPrimaryCharacteristic:(NSString *) actionIdForSettingPrimaryCharacteristic
withActionIdForUnsettingPrimaryCharacteristic:(NSString *) actionIdForUnsettingPrimaryCharacteristic;

- (HMCharacteristic *) characteristicWithType : (NSString *) characteristicType
                                   forService : (HMService *) service;

- (NSNumber *) convertValueOfCharacteristic:(HMCharacteristic *) characteristic
                           toTargetRangeMin:(NSNumber *) targetMin
                           toTargetRangeMax:(NSNumber *) targetMax;

- (void) writeTargetValue:(id) targetValue
      fromCurrentRangeMin:(NSNumber *) currentMin
      fromCurrentRangeMax:(NSNumber *) currentMax
         toCharacteristic:(HMCharacteristic *) characteristic;

@end
