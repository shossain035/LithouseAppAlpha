//
//  LHIgnoreAction.m
//  Lithouse
//
//  Created by Shah Hossain on 5/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHIgnoreAction.h"

NSString * const LHIgnoreActionId = @"IGNORE_ACTION";

@implementation LHIgnoreAction


- (NSString *) friendlyName
{
    return @"Ignore";
}

- (NSString *) identifier
{
    return LHIgnoreActionId;
}


- (void) performAction
{
    //calls no one
}
@end
