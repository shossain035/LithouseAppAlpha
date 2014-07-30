//
//  LHSchedule.m
//  Lithouse
//
//  Created by Shah Hossain on 6/30/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//
#import "LHSchedule.h"

NSString * const LHScheduleCollectionChangedNotification = @"LHScheduleCollectionChangedNotification";

NSArray * getRepeatModeNames ()
{
    static dispatch_once_t pred;
    static NSArray * nameArray = nil;
    
    dispatch_once(&pred, ^{
        nameArray = @[@"Never", @"Every Day", @"Every Week"];
    });
    
    return nameArray;
}

NSString * stringWithLHScheduleTimerRepeatMode (LHScheduleTimerRepeatMode mode)
{
    return getRepeatModeNames() [mode];
}