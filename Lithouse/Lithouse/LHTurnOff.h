//
//  LHTurnOff.h
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHAction.h"

@protocol LHTurnOffHandler <LHActionHandler>

- (void) turnOff;

@end

@interface LHTurnOff : LHAction <LHActionInitiator>

@end