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

@implementation LHHomeKitBulb

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory
{
    if ( self = [super initWithHMAccessory:accessory] ) {
        self.displayImage = [UIImage imageNamed : @"hue"];
        
        [self addToPermissibleActions : [[LHAction alloc] initWithTargetDevice:self
                                                            withActionSelector:@selector(turnOn)
                                                          withActionIdentifier:LHTurnOnActionId]];
        
        [self addToPermissibleActions : [[LHAction alloc] initWithTargetDevice:self
                                                            withActionSelector:@selector(turnOff)
                                                          withActionIdentifier:LHTurnOffActionId]];
        
        [self readPowerStateForServiceType:HMServiceTypeLightbulb];
    }
    
    return self;
}

- (void) turnOn
{
    NSLog ( @"turning HM bulb on");
    [self writePowerState:@(1) forServiceType:HMServiceTypeLightbulb];
}

- (void) turnOff
{
    NSLog ( @"turning HM bulb off");
    [self writePowerState:@(0) forServiceType:HMServiceTypeLightbulb];
}

- (void) toggle
{
    NSLog ( @"toggling hue");
    
    if ( self.currentStatus == LHDeviceIsOn ) {
        [self turnOff];
    } else {
        [self turnOn];
    }
}

#pragma mark ColoredLight
- (void) updateColor : (UIColor *) toColor
{
}

- (UIColor *) getCurrentColor;
{
    return nil;
}

@end
