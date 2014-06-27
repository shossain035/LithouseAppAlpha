//
//  LHAction.m
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHAction.h"

NSString * const LHTurnOnActionId  = @"TURN_ON_ACTION";
NSString * const LHTurnOffActionId = @"TURN_OFF_ACTION";
NSString * const LHLockActionId    = @"LOCK_ACTION";
NSString * const LHUnlockActionId  = @"UNLOCK_ACTION";
NSString * const LHIgnoreActionId  = @"IGNORE_ACTION";

@interface LHAction ()
@property  (weak)   id targetDevice;
@property  (assign) SEL action;
@end

@implementation LHAction

- (id) initWithTargetDevice : (id) aDevice
         withActionSelector : (SEL) anAction
       withActionIdentifier : (NSString *) anActionId
{
    if ( self = [super init] ) {
        self.targetDevice = aDevice;
        self.action = anAction;
        _identifier = anActionId;
    }
    
    return self;
}

- (void) performAction
{
    if ( self.targetDevice != nil && self.action != nil ) {
        
        IMP imp = [self.targetDevice methodForSelector:self.action];
        void (*func)(id, SEL) = (void *)imp;
        func(self.targetDevice, self.action);
    }
}

- (NSString *) friendlyName
{
    return [[LHAction friendlyNameForActionId] objectForKey:self.identifier];
}

+(NSDictionary *) friendlyNameForActionId {
    
    static dispatch_once_t pred;
    static NSDictionary * sharedDictionary = nil;
    
    dispatch_once(&pred, ^{
        sharedDictionary = @{LHTurnOnActionId:@"Turn On",
                             LHTurnOffActionId:@"Turn Off",
                             LHLockActionId:@"Lock",
                             LHUnlockActionId:@"Unlock",
                             LHIgnoreActionId:@"Ignore"};
    });
    
    return sharedDictionary;
}

@end
