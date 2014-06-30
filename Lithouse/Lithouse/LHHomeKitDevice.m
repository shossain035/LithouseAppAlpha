//
//  LHHomeKitDevice.m
//  Lithouse
//
//  Created by Shah Hossain on 6/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitDevice.h"
#import "LHAction.h"
#import "LHHomeKitSchedule.h"
#import <HomeKit/HomeKit.h>
#include <stdlib.h>

static NSString * const LHHomeKitResourceTypeTrigger   = @"trigger";
static NSString * const LHHomeKitResourceTypeActionSet = @"actionset";

@interface LHHomeKitDevice ()
@property (nonatomic, strong, readonly) HMCharacteristic   * primaryCharacteristic;
@property (nonatomic, strong, readonly) HMHome             * home;
@end

@implementation LHHomeKitDevice

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
              withPrimaryServiceType:(NSString *) serviceType
              withCharacteristicType:(NSString *) characteristicType
withActionIdForSettingPrimaryCharacteristic:(NSString *) actionIdForSettingPrimaryCharacteristic
withActionIdForUnsettingPrimaryCharacteristic:(NSString *) actionIdForUnsettingPrimaryCharacteristic
                              inHome:(HMHome *) home

{
    self = [super init];
    if (!self) return nil;;
    
    _accessory = accessory;
    self.friendlyName = accessory.name;
    _home = home;
    
    if (!accessory.configured) {
        self.currentStatus = LHDeviceIsUnPaired;
    } else if (serviceType != nil && characteristicType != nil ) {
        _primaryService = [self serviceForType:serviceType];
        _primaryCharacteristic = [self characteristicWithType:characteristicType
                                                   forService:self.primaryService];
        //todo: what if we cannot fetch services now?
        [self readPrimaryCharacteristic];
        //todo: move these to LHDevice
        [self addToPermissibleActions : [[LHAction alloc] initWithTargetDevice:self
                                                            withActionSelector:@selector(setPrimaryCharacteristic)
                                                          withActionIdentifier:actionIdForSettingPrimaryCharacteristic]];
        
        [self addToPermissibleActions : [[LHAction alloc] initWithTargetDevice:self
                                                            withActionSelector:@selector(unsetPrimaryCharacteristic)
                                                          withActionIdentifier:actionIdForUnsettingPrimaryCharacteristic]];
        
//        for (HMService * service in accessory.services) {
//            NSLog(@"service: %@", service.serviceType);
//            
//            for (HMCharacteristic * characteristic in service.characteristics) {
//                NSLog(@"characteristic: %@ property: %@", characteristic.characteristicType, characteristic.properties);
//            }
//        }
        
    }
    
    return self;
}

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
                              inHome:(HMHome *) home;
{
    
    return [self initWithHMAccessory:accessory
              withPrimaryServiceType:nil
              withCharacteristicType:nil
withActionIdForSettingPrimaryCharacteristic:nil
withActionIdForUnsettingPrimaryCharacteristic:nil
                              inHome:home];
}

- (NSString *) identifier
{
    return self.accessory.identifier.UUIDString;
}

//todo: move these to LHDevice
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

- (NSNumber *) convertValueOfCharacteristic:(HMCharacteristic *) characteristic
                           toTargetRangeMin:(NSNumber *) targetMin
                           toTargetRangeMax:(NSNumber *) targetMax
{
    if ( characteristic.metadata.minimumValue == nil
        || characteristic.metadata.maximumValue == nil ) {
        return characteristic.value;
    }
    
    return [self convertValue:characteristic.value
          fromCurrentRangeMin:characteristic.metadata.minimumValue
          fromCurrentRangeMax:characteristic.metadata.maximumValue
             toTargetRangeMin:targetMin
             toTargetRangeMax:targetMax];
}

- (NSNumber *) convertValue : (NSNumber *) currentValue
        fromCurrentRangeMin : (NSNumber *) currentMin
        fromCurrentRangeMax : (NSNumber *) currentMax
toTargetRangeForCharacteristic : (HMCharacteristic *) characteristic
{
    if ( characteristic.metadata.minimumValue == nil
        || characteristic.metadata.maximumValue == nil ) {
        return currentValue;
    }
    

    return [self convertValue:currentValue
          fromCurrentRangeMin:currentMin
          fromCurrentRangeMax:currentMax
             toTargetRangeMin:characteristic.metadata.minimumValue
             toTargetRangeMax:characteristic.metadata.maximumValue];
}

- (NSNumber *) convertValue : (NSNumber *) currentValue
        fromCurrentRangeMin : (NSNumber *) currentMin
        fromCurrentRangeMax : (NSNumber *) currentMax
           toTargetRangeMin : (NSNumber *) targetMin
           toTargetRangeMax : (NSNumber *) targetMax
{
    NSNumber * currentRange = @(currentMax.doubleValue - currentMin.doubleValue);
    if ([currentRange isEqualToNumber:@(0)]) return currentValue;
        
    NSNumber * targetRange = @(targetMax.doubleValue - targetMin.doubleValue);
    
    return @(targetMin.doubleValue
        + (currentValue.doubleValue * targetRange.doubleValue)
        / currentRange.doubleValue);
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
                     if (completion != nil) {
                         completion ( targetValue );
                     }
                 } else {
                     //todo: alert user
                     NSLog(@"could not write characteristic: %@", error);
                 }
             }];
    
}

- (void) writeTargetValue:(id) targetValue
      fromCurrentRangeMin:(NSNumber *) currentMin
      fromCurrentRangeMax:(NSNumber *) currentMax
         toCharacteristic:(HMCharacteristic *) characteristic
{
    //turn the accessory on if its not already on
    if (self.currentStatus != LHDeviceIsOn) {
        [self setPrimaryCharacteristic];
    }
    
    [self writeTargetValue:[self convertValue:targetValue
                          fromCurrentRangeMin:currentMin
                          fromCurrentRangeMax:currentMax
               toTargetRangeForCharacteristic:characteristic]
          toCharacteristic:characteristic
     withCompletionHandler:nil];
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
            if (completion != nil) {
                completion ( characteristic.value );
            }
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
            //initial read
            [self readCharacteristic:characteristic withCompletionHandler:nil];
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

#pragma mark <LHScheduleing>

//todo: move schedule code to LHHomeKitSchedule
- (id<LHSchedule>) createSchedule
{
    return [[LHHomeKitSchedule alloc] initWithDevice:self
                                          withAction:[self actionForActionId:self.defaultActionId]];
}

- (void) saveSchedule:(id<LHSchedule>)schedule
{
    LHHomeKitSchedule * homeKitSchedule = (LHHomeKitSchedule *) schedule;
    
    if (!homeKitSchedule.homeKitTrigger) {
        [self createAndUpdateTriggerForSchedule:homeKitSchedule];
    } else {
        [(HMTimerTrigger *) homeKitSchedule.homeKitTrigger updateFireDate:schedule.fireDate
                                                        completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"failed to update trigger fire date. %@", error);
                return;
            }
            //todo: update recurrance then nest enable
            [self updateTrigger:homeKitSchedule.homeKitTrigger
                   withSchedule:homeKitSchedule];
        }];
        
        
    }
}

- (void) updateTrigger:(HMTrigger *) trigger
          withSchedule:(LHHomeKitSchedule *) schedule
{
    //remove all actions
    if (!trigger) {
        NSLog(@"nil trigger");
        return;
    }
    
    HMActionSet * actionSet = trigger.actionSets [0];
    NSArray * oldActions = [actionSet.actions allObjects];
    
    for ( HMAction * action in oldActions ) {
        
        [actionSet removeAction:action completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"failed to remove old action. %@", error);
            }
        }];
    }
    
    HMAction * newAction = [self getHomeKitActionForLHAction:schedule.action];
    if ( !newAction ) {
        NSLog(@"no action found for id: %@", schedule.action.identifier);
        return; //todo: throw error to user
    }
    
    [actionSet addAction:newAction completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"failed to add new action. %@", error);
            return;
        }
        
        [self enableSchedule:schedule];
    }];
}

//todo: remove trigger and action set in case of failure
- (void) createAndUpdateTriggerForSchedule : (LHHomeKitSchedule *) homeKitSchedule
{
    NSString * uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    __weak __typeof(self) weakSelf = self;
    
    [self.home addActionSetWithName:
     [NSString stringWithFormat:@"%@ %@", [weakSelf getHomeKitPreambleForType:LHHomeKitResourceTypeActionSet], uuid]
                  completionHandler:^(HMActionSet *actionSet, NSError *error) {
                      if ( error) {
                          NSLog(@"failed to create new action set. %@", error);
                          return;
                      }
                      
                      //todo: correct recurrance
                      HMTrigger * trigger = [[HMTimerTrigger alloc] initWithName:
                                             [NSString stringWithFormat:@"%@ %@", [weakSelf getHomeKitPreambleForType:LHHomeKitResourceTypeTrigger], uuid]
                                                                        fireDate:homeKitSchedule.fireDate
                                                                        timeZone:nil
                                                                      recurrence:nil
                                                              recurrenceCalendar:nil];
                
                      [weakSelf.home addTrigger:trigger completionHandler:^(NSError *error) {
                          if ( error ) {
                              NSLog(@"failed to add trigger: %@", error);
                              return;
                          }
                          __weak __typeof(trigger) weakTrigger = trigger;
                          
                          [trigger addActionSet:actionSet completionHandler:^(NSError *error) {
                              if ( error) {
                                  NSLog(@"failed to add action set. %@", error);
                                  return;
                              }
                              
                              homeKitSchedule.homeKitTrigger = weakTrigger;
                              [weakSelf updateTrigger:weakTrigger
                                         withSchedule:homeKitSchedule];
                          }];
                          
                      }];
    }];
}

- (NSString *) getHomeKitPreambleForType : (NSString *) type
{
    return [NSString stringWithFormat:@"lithouse %@ %@", self.friendlyName, type];
}

- (void) removeSchedule:(id<LHSchedule>)schedule
{
    HMTrigger * trigger = ((LHHomeKitSchedule *) schedule).homeKitTrigger;
    
    for ( HMActionSet * actionSet in trigger.actionSets ) {
        [self.home removeActionSet:actionSet completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"failed to remove action set. %@", error);
            }

        }];
    }
    
    [self.home removeTrigger:trigger completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"failed to remove trigger. %@", error);
            return;
        }
        
        NSLog(@"removed trigger.");
    }];
}

- (NSArray *) getSchedules
{
    NSString * preambleForTrigger = [self getHomeKitPreambleForType:LHHomeKitResourceTypeTrigger];
    NSMutableArray * schedules = [[NSMutableArray alloc] init];
    
    for ( HMTrigger * trigger in self.home.triggers ) {
        
        if ( [trigger.name hasPrefix:preambleForTrigger] ) {
            LHAction * action = [self getLHActionForHoomeKitActionSet:trigger.actionSets[0]];
            LHHomeKitSchedule * schedule = [[LHHomeKitSchedule alloc] initWithDevice:self
                                                                          withAction:action
                                                                         withTrigger:trigger];
            [schedules addObject:schedule];
        }
    }
    
    return [schedules copy];
}

- (void) enableSchedule : (id<LHSchedule>) schedule
{
    LHHomeKitSchedule * homeKitSchedule = schedule;
    HMTimerTrigger * timerTrigger = (HMTimerTrigger *) homeKitSchedule.homeKitTrigger;
    //check if trigger date is in the past
    if ([timerTrigger.fireDate timeIntervalSinceNow] < 0.0) {
        [homeKitSchedule moveFireDateToFuture];
        [timerTrigger updateFireDate:schedule.fireDate
                   completionHandler:^(NSError *error) {
                       if (error) {
                           NSLog(@"failed to update trigger fire date. %@", error);
                           return;
                       }
                       
                       [self enableTrigger:timerTrigger enabled:schedule.enabled];
                   }];
    } else {
        [self enableTrigger:timerTrigger enabled:schedule.enabled];
    }
    
}

- (void) enableTrigger : (HMTrigger *) trigger enabled : (BOOL) isEnabled
{
    [trigger enable:isEnabled completionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"failed to enable trigger: %@", error);
            return;
        }
        
        NSLog(@"updated trigger: %@", trigger.name);
    }];
}

//todo: consider other types of actions and make it a base function
- (HMAction *) getHomeKitActionForLHAction : (LHAction *) lhAction
{
    int targetValue;
    
    if ([lhAction.identifier isEqualToString:LHTurnOnActionId]) {
        targetValue = 1;
    } else if ([lhAction.identifier isEqualToString:LHTurnOffActionId]) {
        targetValue = 0;
    } else {
        return nil;
    }
    
    return [[HMCharacteristicWriteAction alloc] initWithCharacteristic:self.primaryCharacteristic
                                                           targetValue:@(targetValue)];
}


//todo: make it robust in accordance with getHomeKitActionForLHAction
- (LHAction *) getLHActionForHoomeKitActionSet:(HMActionSet *) actionSet
{
    for ( HMCharacteristicWriteAction * action in actionSet.actions ) {
        if ( [action.targetValue integerValue] == 1 ) {
            return [self actionForActionId:LHTurnOnActionId];
        } else if ( [action.targetValue integerValue] == 0 ) {
            return [self actionForActionId:LHTurnOffActionId];
        }
    }
        
    return nil;
}

@end
