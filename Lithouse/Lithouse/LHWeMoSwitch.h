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
#import "LHToggle.h"

#import "WeMoControlDevice.h"

@interface LHWeMoSwitch : LHDevice <LHTurnOnHandler,
                                    LHTurnOffHandler,
                                    LHToogleHandler>

- (id) initWithWeMoControlDevice : (WeMoControlDevice *) aWeMoControlDevice;

@property (nonatomic, strong) WeMoControlDevice * weMoControlDevice;
@end
