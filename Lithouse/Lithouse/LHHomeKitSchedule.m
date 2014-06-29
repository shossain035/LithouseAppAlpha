//
//  LHHomeKitSchedule.m
//  Lithouse
//
//  Created by Shah Hossain on 6/27/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitSchedule.h"
#import "DeviceProtocols.h"

@implementation LHHomeKitSchedule

@synthesize device = _device;
@synthesize action = _action;
@synthesize selectedWeekdays = _selectedWeekdays;
@synthesize disabled = _disabled;
@synthesize fireDate = _fireDate;

- (instancetype) initWithDevice : (id <LHScheduleing>) aDevice
                     withAction : (LHAction *) anAction
{
    self = [super init];
    if (!self) return nil;
    
    _device = aDevice;
    _action = anAction;
    _disabled = NO;
    _fireDate = [NSDate date];
    _selectedWeekdays = [@[@YES,@YES,@YES,@YES,@YES,@YES,@YES] mutableCopy];

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

@end
