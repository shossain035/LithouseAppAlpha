//
//  LHAction.h
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LHTurnOnActionId;
extern NSString * const LHTurnOffActionId;
extern NSString * const LHLockActionId;
extern NSString * const LHUnlockActionId;

extern NSString * const LHIgnoreActionId;

@interface LHAction : NSObject

@property (nonatomic, strong, readonly) NSString * identifier;

- (id) initWithTargetDevice : (id) aDevice
         withActionSelector : (SEL) anAction
       withActionIdentifier : (NSString *) anActionId;

- (NSString *) friendlyName;
- (void) performAction;

@end
