//
//  LHHomeKitDevice.m
//  Lithouse
//
//  Created by Shah Hossain on 6/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitDevice.h"
#import "LHAction.h"
#import <HomeKit/HomeKit.h>

@interface LHHomeKitDevice ()
@property (nonatomic, strong, readonly) HMCharacteristic   * primaryCharacteristic;

@end

@implementation LHHomeKitDevice

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
              withPrimaryServiceType:(NSString *) serviceType
              withCharacteristicType:(NSString *) characteristicType
withActionIdForSettingPrimaryCharacteristic:(NSString *) actionIdForSettingPrimaryCharacteristic
withActionIdForUnsettingPrimaryCharacteristic:(NSString *) actionIdForUnsettingPrimaryCharacteristic

{
    self = [super init];
    if (!self) return nil;;
    
    _accessory = accessory;
    self.friendlyName = accessory.name;
    
    if (!accessory.configured) {
        self.currentStatus = LHDeviceIsUnPaired;
    } else if (serviceType != nil && characteristicType != nil ) {
        _primaryService = [self serviceForType:serviceType];
        _primaryCharacteristic = [self characteristicWithType:characteristicType
                                                   forService:self.primaryService];
        //todo: what if we cannot fetch services now?
        [self readPrimaryCharacteristic];
        
        [self addToPermissibleActions : [[LHAction alloc] initWithTargetDevice:self
                                                            withActionSelector:@selector(setPrimaryCharacteristic)
                                                          withActionIdentifier:actionIdForSettingPrimaryCharacteristic]];
        
        [self addToPermissibleActions : [[LHAction alloc] initWithTargetDevice:self
                                                            withActionSelector:@selector(unsetPrimaryCharacteristic)
                                                          withActionIdentifier:actionIdForUnsettingPrimaryCharacteristic]];
        
    }
    
    self.displayImage = [UIImage imageNamed : @"unknown"];

    
    return self;
}

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
{
    
    return [self initWithHMAccessory:accessory
              withPrimaryServiceType:nil
              withCharacteristicType:nil
withActionIdForSettingPrimaryCharacteristic:nil
withActionIdForUnsettingPrimaryCharacteristic:nil];
}

- (NSString *) identifier
{
    return self.accessory.identifier.UUIDString;
}

- (void) setPrimaryCharacteristic
{
    NSLog ( @"turning HM device on");
    [self writePrimaryCharacteristic:@(1)];
}

- (void) unsetPrimaryCharacteristic
{
    NSLog ( @"turning HM device off");
    [self writePrimaryCharacteristic:@(0)];
}

- (void) toggle
{
    NSLog ( @"toggling HM device");
    
    if ( self.currentStatus == LHDeviceIsOn ) {
        [self unsetPrimaryCharacteristic];
    } else {
        [self setPrimaryCharacteristic];
    }
}

- (void) writePrimaryCharacteristic:(id)targetValue
{
    [self writeTargetValue:targetValue
          toCharacteristic:self.primaryCharacteristic
     withCompletionHandler:^(id value) {
           if ( [value boolValue] == YES ) {
               self.currentStatus = LHDeviceIsOn;
           } else {
               self.currentStatus = LHDeviceIsOff;
           }
    }];
}

- (void) writeTargetValue : (id) targetValue
         toCharacteristic : (HMCharacteristic *) characteristic
    withCompletionHandler : (void (^)(id value))completion
{
    if (!characteristic) {
        NSLog(@"could not write. nil values supplied");
        return;
    }
    
    [characteristic writeValue : targetValue
             completionHandler : ^(NSError *error) {
                 if (error == nil) {
                     completion ( targetValue ) ;
                 } else {
                     NSLog(@"could not write characteristic: %@", error);
                 }
             }];
    
}


- (void) readPrimaryCharacteristic
{
    [self readCharacteristic:self.primaryCharacteristic
       withCompletionHandler:^(id value) {
           if ( [value boolValue] == YES ) {
               self.currentStatus = LHDeviceIsOn;
           } else {
               self.currentStatus = LHDeviceIsOff;
           }
    }];
}

- (void) readCharacteristic : (HMCharacteristic *) characteristic
      withCompletionHandler : (void (^)(id value))completion
{
    
    if (!characteristic) {
        NSLog(@"could not read. nil values supplied");
        return;
    }
    
    [characteristic readValueWithCompletionHandler : ^(NSError *error) {
        if (error == nil) {
            completion ( characteristic.value ) ;
        } else {
            NSLog(@"could not read characteristic: %@", error);
        }
    }];
    
}

- (HMCharacteristic *) characteristicWithType : (NSString *) characteristicType
                                   forService : (HMService *) service
{
    if (service == nil) return nil;
    
    for ( HMCharacteristic * characteristic in service.characteristics ) {
        if ( [characteristic.characteristicType isEqualToString : characteristicType]) {
            return characteristic;
        }
    }
    
    return nil;
}

- (HMService *) serviceForType : (NSString *) serviceType
{
    for ( HMService * service in self.accessory.services ) {
        if ( [service.serviceType isEqualToString : serviceType] ) {
            return service;
        }
    }
    
    return nil;
}

@end
