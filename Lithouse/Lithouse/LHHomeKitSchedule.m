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
@synthesize enabled = _enabled;
@synthesize fireDate = _fireDate;
@synthesize repeatMode = _repeatMode;

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
        
        NSCalendar* currentCalendar = [NSCalendar currentCalendar];
        NSDateComponents* dateComponents =
            [currentCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute)
                               fromDate:[NSDate date]];
        
        _fireDate = [currentCalendar dateFromComponents:dateComponents];
        
        _repeatMode = LHRepeatDaily;
    } else {
        _enabled = trigger.enabled;
        _repeatMode = [self repeatModeFromDateComponents:((HMTimerTrigger *)trigger).recurrence];
        HMTimerTrigger * timerTrigger = (HMTimerTrigger *) trigger;
        _fireDate = timerTrigger.fireDate;
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

- (NSDate *) moveFireDateToFuture
{
    if ([self.fireDate timeIntervalSinceNow] > 0.0) {
        return self.fireDate;
    }
    
    NSLog(@"past time: %@", self.fireDate);
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * today = [NSDate date];
    self.fireDate = [calendar dateBySettingHour:[calendar component:NSCalendarUnitHour fromDate:self.fireDate]
                                         minute:[calendar component:NSCalendarUnitMinute fromDate:self.fireDate]
                                         second:[calendar component:NSCalendarUnitSecond fromDate:self.fireDate]
                                         ofDate:today
                                        options:0];
    
    NSLog(@"changed to today time: %@", self.fireDate);
    if ([self.fireDate timeIntervalSinceNow] > 0.0) {
        return self.fireDate;
    }
    
    NSDateComponents * offsetOneDayComponent = [[NSDateComponents alloc] init];
    offsetOneDayComponent.day = 1;
    
    self.fireDate = [calendar dateByAddingComponents:offsetOneDayComponent
                                              toDate:self.fireDate
                                             options:0];
    
    NSLog(@"changed to tomorrow time: %@", self.fireDate);
    
    return self.fireDate;
}

- (LHScheduleTimerRepeatMode) repeatModeFromDateComponents:(NSDateComponents *) dateComponents
{
    if (dateComponents.day == 1) {
        return LHRepeatDaily;
    }  else if (dateComponents.day == 7) {
        return LHRepeatWeekly;
    }
        
    return LHRepeatNever;
}

- (NSDateComponents *) dateComponentsForRecurrance
{
    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    
    if ( self.repeatMode == LHRepeatDaily ) {
        dateComponents.day = 1;
    } else if ( self.repeatMode == LHRepeatWeekly ) {
        dateComponents.day = 7;
    } else {
        dateComponents = nil;
    }
    
    return dateComponents;
}

-(void) setRepeatMode:(LHScheduleTimerRepeatMode)repeatMode
{
    _repeatMode = repeatMode;
    _enabled = YES;
}

- (void) setFireDate:(NSDate *)fireDate
{
    _fireDate = fireDate;
    _enabled = YES;
}

- (void) setAction:(LHAction *)action
{
    _action = action;
    _enabled = YES;
}

@end
