//
//  LHHueBulb.h
//  Lithouse
//
//  Created by Shah Hossain on 5/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"
#import "DeviceProtocols.h"

@class PHLight;
@interface LHHueBulb : LHDevice <LHLightColorChanging>


- (id) initWithPHLight : (PHLight *) aPHLight;
- (void) updateWithPHLight : (PHLight *) aPHLight;

@property (nonatomic, strong) PHLight * phLight;

@end
