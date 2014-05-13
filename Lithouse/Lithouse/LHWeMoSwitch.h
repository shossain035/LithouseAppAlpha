//
//  LHWeMoSwitch.h
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"
#import "LHTurnOn.h"
#import "LHTurnOff.h"

@interface LHWeMoSwitch : LHDevice <LHTurnOnHandler, LHTurnOffHandler>

@end
