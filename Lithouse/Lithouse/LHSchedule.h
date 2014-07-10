//
//  LHSchedule.h
//  Lithouse
//
//  Created by Shah Hossain on 6/27/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#ifndef Lithouse_Schedule_h
#define Lithouse_Schedule_h

@class LHAction;
@protocol LHScheduleing;

extern NSString * const LHScheduleCollectionChangedNotification;

typedef NS_ENUM ( NSUInteger, LHScheduleTimerRepeatMode ) {
    LHRepeatNever,
    LHRepeatDaily,
    LHRepeatWeekly,
    LHRepeatModesCount
};

NSString * stringWithLHScheduleTimerRepeatMode (LHScheduleTimerRepeatMode mode);

@protocol LHSchedule <NSObject>
@property (nonatomic, weak, readonly) id <LHScheduleing> device;
@property (nonatomic, weak) LHAction * action;
@property (nonatomic, assign, readonly) BOOL enabled;
@property (nonatomic, strong) NSDate * fireDate;
@property (nonatomic, assign) LHScheduleTimerRepeatMode repeatMode;

- (instancetype) initWithDevice : (id <LHScheduleing>) aDevice
                     withAction : (LHAction *) anAction;
- (void) save;
- (void) remove;
- (void) enable:(BOOL) isEnabled;
@end


#endif
