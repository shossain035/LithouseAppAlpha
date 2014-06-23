//
//  LHHomeKitDevice.m
//  Lithouse
//
//  Created by Shah Hossain on 6/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitDevice.h"
#import <HomeKit/HomeKit.h>

@implementation LHHomeKitDevice

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
{
    if ( self = [self init] ) {
        _accessory = accessory;
        self.friendlyName = accessory.name;
        
        if (!accessory.configured) {
            self.currentStatus = LHDeviceIsUnPaired;
        }
        
        self.displayImage = [UIImage imageNamed : @"unknown"];
    }
    
    return self;
}


- (NSString *) identifier
{
    return self.accessory.identifier.UUIDString;
}

- (void) toggle
{
    NSLog(@"Unknown home kit device: %@", self.accessory);
    //todo: alert user
}

- (void) writePowerState:(id)targetValue
          forServiceType:(NSString*)serviceType
{
    [self writeCharacteristic:targetValue
                     withType:HMCharacteristicTypePowerState
               forServiceType:serviceType
        withCompletionHandler:^(id value) {
                   if ( [value boolValue] == YES ) {
                       self.currentStatus = LHDeviceIsOn;
                   } else {
                       self.currentStatus = LHDeviceIsOff;
                   }
    }];
}

- (void) writeCharacteristic : (id) targetValue
                    withType : (NSString *) characteristicType
              forServiceType : (NSString *) serviceType
       withCompletionHandler : (void (^)(id value))completion
{
    if ( !self.accessory.configured ) {
        NSLog(@"trying to write unpaired accessory: %@", self.accessory);
        return;
    }
    
    HMCharacteristic * characteristic = [self characteristicWithType:characteristicType
                                                      forServiceType:serviceType];
    
    if (!characteristic) return;
    
    [characteristic writeValue : targetValue
             completionHandler : ^(NSError *error) {
                 if (error == nil) {
                     completion ( targetValue ) ;
                 } else {
                     NSLog(@"could not write characteristic: %@", error);
                 }
             }];
    
}


- (void) readPowerStateForServiceType:(NSString*) serviceType
{
    [self readCharacteristicWithType:HMCharacteristicTypePowerState
                      forServiceType:serviceType
               withCompletionHandler:^(id value) {
                   if ( [value boolValue] == YES ) {
                       self.currentStatus = LHDeviceIsOn;
                   } else {
                       self.currentStatus = LHDeviceIsOff;
                   }
    }];
}

- (void) readCharacteristicWithType : (NSString *) characteristicType
                     forServiceType : (NSString *) serviceType
              withCompletionHandler : (void (^)(id value))completion
{
    if ( !self.accessory.configured ) return;
    
    HMCharacteristic * characteristic = [self characteristicWithType:characteristicType
                                                      forServiceType:serviceType];
    
    if (!characteristic) return;
    
    [characteristic readValueWithCompletionHandler : ^(NSError *error) {
        if (error == nil) {
            completion ( characteristic.value ) ;
        } else {
            NSLog(@"could not read characteristic: %@", error);
        }
    }];
    
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

- (HMCharacteristic *) characteristicWithType : (NSString *) characteristicType
                               forServiceType : (NSString *) serviceType
{
    HMService * service = [self serviceForType:serviceType];
    
    if (!service) return nil;
    
    for ( HMCharacteristic * characteristic in service.characteristics ) {
        if ( [characteristic.characteristicType isEqualToString : characteristicType]) {
            return characteristic;
        }
    }
    
    return nil;
}

@end
