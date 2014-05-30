//
//  LHAction.m
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHAction.h"

NSString * const LHDefaultActionId = @"TURN_ON_ACTION";

@implementation LHAction

- (id) initWithParentDevice : (id <LHActionHandler>) aDevice
{
    if ( self = [super init] ) {
        self.parentDevice = aDevice;
    }
    
    return self;
}

@end
