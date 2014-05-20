//
//  LHToggle.h
//  Lithouse
//
//  Created by Shah Hossain on 5/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHAction.h"

@protocol LHToogleHandler <LHActionHandler>

- (void) toggle;

@end


@interface LHToggle : LHAction

@end
