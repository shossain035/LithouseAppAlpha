//
//  LHHomeKitDevice.h
//  Lithouse
//
//  Created by Shah Hossain on 6/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"
#import "DeviceProtocols.h"

@class HMAccessory;
@class HMService;
@class HMCharacteristic;
@class HMAction;
@class HMHome;

@interface LHHomeKitDevice : LHDevice <LHScheduleing>

@property (nonatomic, strong, readonly) HMAccessory        * accessory;
@property (nonatomic, strong, readonly) HMService          * primaryService;
@property (nonatomic, strong, readonly) HMCharacteristic   * primaryTargetCharacteristic;
@property (nonatomic, strong, readonly) HMCharacteristic   * primaryCurrentCharacteristic;


- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
                              inHome:(HMHome *) home;

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
              withPrimaryServiceType:(NSString *) serviceType
              withCharacteristicType:(NSString *) characteristicType
withActionIdForSettingPrimaryCharacteristic:(NSString *) actionIdForSettingPrimaryCharacteristic
withActionIdForUnsettingPrimaryCharacteristic:(NSString *) actionIdForUnsettingPrimaryCharacteristic
                            inHome:(HMHome *) home;

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
              withPrimaryServiceType:(NSString *) serviceType
 withPrimaryTargetCharacteristicType:(NSString *) targetCharacteristicType
withPrimaryCurrentCharacteristicType:(NSString *) currentCharacteristicType
withActionIdForSettingPrimaryCharacteristic:(NSString *) actionIdForSettingPrimaryCharacteristic
withActionIdForUnsettingPrimaryCharacteristic:(NSString *) actionIdForUnsettingPrimaryCharacteristic
withPrimPrimaryCharacteristicValueOn:(id) onValue
withPrimPrimaryCharacteristicValueOff:(id) offValue
                              inHome:(HMHome *) home;



- (HMCharacteristic *) characteristicWithType : (NSString *) characteristicType
                                   forService : (HMService *) service;

- (NSNumber *) convertValueOfCharacteristic:(HMCharacteristic *) characteristic
                           toTargetRangeMin:(NSNumber *) targetMin
                           toTargetRangeMax:(NSNumber *) targetMax;

- (void) writeTargetValue:(id) targetValue
      fromCurrentRangeMin:(NSNumber *) currentMin
      fromCurrentRangeMax:(NSNumber *) currentMax
         toCharacteristic:(HMCharacteristic *) characteristic;

- (void) writeTargetValue : (id) targetValue
         toCharacteristic : (HMCharacteristic *) characteristic
    withCompletionHandler : (void (^)(id value))completion;

- (void) writePrimaryTargetCharacteristic:(id)targetValue;

- (void) readCharacteristic : (HMCharacteristic *) characteristic
      withCompletionHandler : (void (^)(id value))completion;

- (void) readPrimaryCurrentCharacteristic;

@end
