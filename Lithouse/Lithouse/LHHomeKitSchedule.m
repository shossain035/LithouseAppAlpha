//
//  LHHomeKitSchedule.m
//  Lithouse
//
//  Created by Shah Hossain on 6/27/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitSchedule.h"
#import "DeviceProtocols.h"
#import <HomeKit/HomeKit.h>

@implementation LHHomeKitSchedule

@synthesize device = _device;
@synthesize action = _action;
@synthesize selectedWeekdays = _selectedWeekdays;
@synthesize enabled = _enabled;
@synthesize fireDate = _fireDate;

- (instancetype) initWithDevice : (id <LHScheduleing>) aDevice
                     withAction : (LHAction *) anAction
{
    return [self initWithDevice:aDevice withAction:anAction withTrigger:nil];
}

- (instancetype) initWithDevice : (id <LHScheduleing>) aDevice
                     withAction : (LHAction *) anAction
                    withTrigger : (HMTrigger *) trigger
{
    self = [super init];
    if (!self) return nil;
    _device = aDevice;
    _action = anAction;
    _homeKitTrigger = trigger;
    
    if ( !trigger ) {
        _enabled = YES;
        _fireDate = [NSDate date];
        _selectedWeekdays = [@[@YES,@YES,@YES,@YES,@YES,@YES,@YES] mutableCopy];
    } else {
        _enabled = trigger.enabled;
        
        HMTimerTrigger * timerTrigger = (HMTimerTrigger *) trigger;
        _fireDate = timerTrigger.fireDate;
        //todo: selected weekdays based on recurrance
        //todo: handle the case of repeat = NEVER and lastFireDate != nil
    }
    
    return self;
}

- (void) save
{
    [self.device saveSchedule:self];
}

-(void) remove
{
    [self.device removeSchedule:self];
}

- (void) enable:(BOOL) isEnabled
{
    _enabled = isEnabled;
    [self.device enableSchedule:self];
}

@end
