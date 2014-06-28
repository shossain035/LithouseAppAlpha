//
//  LHScheduleViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 6/26/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHDevice;
@protocol LHSchedule;

@interface LHScheduleViewController : UIViewController

@property (nonatomic, weak)   LHDevice * device;
@property (nonatomic, strong) id<LHSchedule> schedule;
@property (nonatomic, assign) BOOL isNewSchedule;

@end
