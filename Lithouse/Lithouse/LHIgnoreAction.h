//
//  LHIgnoreAction.h
//  Lithouse
//
//  Created by Shah Hossain on 5/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHAction.h"

extern NSString * const LHIgnoreActionId;

@protocol LHIgnoreActionHandler <LHActionHandler>

@end

@interface LHIgnoreAction : LHAction

@end
