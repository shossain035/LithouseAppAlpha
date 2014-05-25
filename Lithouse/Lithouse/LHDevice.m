//
//  LHDevice.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"

NSString * const LHDeviceDidStatusChangeNotification = @"LHDeviceDidStatusChangeNotification";

@implementation LHDevice

- (id) init
{
    if ( self = [super init] ) {
        self.permissibleActions = [[NSMutableDictionary alloc] init];
        self.displayImage = [UIImage imageNamed : @"unknown"];
        self.currentStatus = LHDeviceIsUnknown;
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

- (void) addToPermissibleActions : (LHAction *) aAction
{
    [self.permissibleActions setObject : aAction forKey : aAction.identifier];
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
@end
