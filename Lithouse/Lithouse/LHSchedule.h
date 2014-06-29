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


@protocol LHSchedule <NSObject>
@property (nonatomic, weak, readonly) id <LHScheduleing> device;
@property (nonatomic, weak) LHAction * action;
@property (nonatomic, assign, readonly) BOOL enabled;
@property (nonatomic, strong) NSMutableArray * selectedWeekdays;
@property (nonatomic, strong) NSDate * fireDate;

- (instancetype) initWithDevice : (id <LHScheduleing>) aDevice
                     withAction : (LHAction *) anAction;
- (void) save;
- (void) remove;
- (void) enable:(BOOL) isEnabled;
@end


#endif
