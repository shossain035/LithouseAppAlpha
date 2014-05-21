//
//  LHHueBulb.h
//  Lithouse
//
//  Created by Shah Hossain on 5/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"
#import "LHTurnOn.h"
#import "LHTurnOff.h"
#import "LHToggle.h"

#import <HueSDK_iOS/HueSDK.h>

@interface LHHueBulb : LHDevice <LHTurnOnHandler,
                                 LHTurnOffHandler,
                                 LHToogleHandler>


- (id) initWithPHLight : (PHLight *) aPHLight;

@property (nonatomic, strong) PHLight * phLight;


@end
