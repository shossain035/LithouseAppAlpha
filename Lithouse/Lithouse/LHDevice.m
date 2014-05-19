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
        self.permissibleActions = [[NSMutableArray alloc] init];
        self.displayImage = [UIImage imageNamed : @"unknown"];
    }
    
    return self;
}

@end
