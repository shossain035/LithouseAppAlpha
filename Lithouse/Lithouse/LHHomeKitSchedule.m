//
//  LHHomeKitSchedule.m
//  Lithouse
//
//  Created by Shah Hossain on 6/27/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitSchedule.h"

@implementation LHHomeKitSchedule

@synthesize device = _device;
@synthesize action = _action;

- (instancetype) initWithDevice : (id <LHScheduleing>) aDevice
                     withAction : (LHAction *) anAction
{
    self = [super init];
    if (!self) return nil;
    
    _device = aDevice;
    _action = anAction;
    
    return self;
}

- (void) save
{
    NSLog(@"save schedule");
}

-(void) remove
{
    NSLog(@"remove schedule");
}

@end
