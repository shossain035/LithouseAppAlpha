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
@property (nonatomic, weak) id <LHScheduleing> device;
@property (nonatomic, weak) LHAction * action;

- (instancetype) initWithDevice : (id <LHScheduleing>) aDevice
                     withAction : (LHAction *) anAction;
- (void) save;
- (void) remove;
@end


#endif
