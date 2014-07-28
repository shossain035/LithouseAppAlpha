//
//  LHDevice.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"
#import "LHAction.h"

@interface LHDevice ()
@property (nonatomic, strong) NSMutableDictionary * permissibleActions;
@property (nonatomic, strong) NSMutableArray      * permissibleActionIds;
@end

NSString * const LHDeviceDidStatusChangeNotification = @"LHDeviceDidStatusChangeNotification";

@implementation LHDevice

- (id) init
{
    if ( self = [super init] ) {
        self.permissibleActions = [[NSMutableDictionary alloc] init];
        self.permissibleActionIds = [[NSMutableArray alloc] init];
        
        self.currentStatus = LHDeviceIsUnknown;
        
        [self addToPermissibleActions : [[LHAction alloc] initWithTargetDevice:nil
                                                            withActionSelector:nil
                                                          withActionIdentifier:LHIgnoreActionId]];
    }
    
    return self;
}

- (void) toggle
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
}

- (NSString *) identifier
{
    NSAssert(NO, @"This is an abstract method and should be overridden");
    return nil;
}

- (void) addToPermissibleActions : (LHAction *) anAction
{
    if (![self.permissibleActions objectForKey : anAction.identifier]) {
        [self.permissibleActionIds addObject : anAction.identifier];
    }
    
    [self.permissibleActions setObject : anAction forKey : anAction.identifier];
}

- (LHAction *) actionForActionId : (NSString *) actionId
{
    return [self.permissibleActions objectForKey : actionId];
}


- (LHAction *) actionAtIndex : (long) index
{
    if ( self.permissibleActionIds.count > index ) {
        return [self.permissibleActions objectForKey :
                [self.permissibleActionIds objectAtIndex : index]];
    }
    return nil;
}

- (NSUInteger) actionCount
{
    return [self.permissibleActions count];
}

- (void) setCurrentStatus : (LHDeviceStatus) currentStatus
{
    _currentStatus = currentStatus;
    
    [self notifyCurrentStatus];
}

- (void) notifyCurrentStatus
{
    NSDictionary * statusData = [NSDictionary dictionaryWithObject : [NSNumber numberWithInt : self.currentStatus]
                                                            forKey : LHDeviceDidStatusChangeNotification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName : LHDeviceDidStatusChangeNotification
                                                        object : self
                                                      userInfo : statusData];
}

- (NSString *) defaultActionId
{
    return LHTurnOnActionId;
}

- (UIImage *) imageForStatus:(LHDeviceStatus) status
{
    return [UIImage imageNamed:@"unknown_device"];
}
@end
