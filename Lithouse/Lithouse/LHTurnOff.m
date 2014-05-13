
//
//  LHTurnOff.m
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHTurnOff.h"

@implementation LHTurnOff

- (NSString *) friendlyName
{
    return @"Turn On";
}

- (void) performAction
{
    [(id <LHTurnOffHandler>) self.parentDevice turnOff];
}

@end
