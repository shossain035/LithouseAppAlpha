//
//  LHDevice.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"

@implementation LHDevice

- (id) init
{
    if ( self = [super init] ) {
        self.permissibleActions = [[NSMutableDictionary alloc] init];
        self.displayImage = [UIImage imageNamed : @"unknown"];
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

- (void) addToPermessibleActions : (LHAction *) aAction
{
    [self.permissibleActions setObject : aAction forKey : aAction.identifier];
}

@end
