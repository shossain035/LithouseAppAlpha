//
//  LHToggle.m
//  Lithouse
//
//  Created by Shah Hossain on 5/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHToggle.h"

@implementation LHToggle

- (NSString *) friendlyName
{
    return @"Toogle";
}

- (NSString *) identifier
{
    return @"TOGGLE_ACTION";
}


- (void) performAction
{
    [(id <LHToogleHandler>) self.parentDevice toggle];
}

@end
