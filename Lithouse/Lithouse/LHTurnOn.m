//
//  LHTurnOn.m
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHTurnOn.h"

@implementation LHTurnOn

- (NSString *) friendlyName
{
    return @"Turn On";
}

- (void) performAction
{
    [(id <LHTurnOnHandler>) self.parentDevice turnOn];
}

@end
