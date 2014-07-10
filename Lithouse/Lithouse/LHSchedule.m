//
//  LHSchedule.m
//  Lithouse
//
//  Created by Shah Hossain on 6/30/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//
#import "LHSchedule.h"

NSString * const LHScheduleCollectionChangedNotification = @"LHScheduleCollectionChangedNotification";

NSString * stringWithLHScheduleTimerRepeatMode (LHScheduleTimerRepeatMode mode)
{
    static dispatch_once_t pred;
    static NSDictionary * nameDictionary = nil;
    
    dispatch_once(&pred, ^{
        nameDictionary = @{@(LHRepeatNever):@"Never",
                           @(LHRepeatDaily):@"Every Day",
                           @(LHRepeatWeekly):@"Every Week"};
    });
    
    return nameDictionary [@(mode)];
}