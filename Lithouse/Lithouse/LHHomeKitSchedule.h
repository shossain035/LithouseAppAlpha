//
//  LHHomeKitSchedule.h
//  Lithouse
//
//  Created by Shah Hossain on 6/27/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHSchedule.h"

@class HMTrigger;
@interface LHHomeKitSchedule : NSObject <LHSchedule>

@property (nonatomic,strong) HMTrigger * homeKitTrigger;

- (instancetype) initWithDevice : (id <LHScheduleing>) aDevice
                     withAction : (LHAction *) anAction
                    withTrigger : (HMTrigger *) trigger;

- (NSDate *) moveFireDateToFuture;

@end
