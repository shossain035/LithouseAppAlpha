//
//  LHHomeKitDevice.h
//  Lithouse
//
//  Created by Shah Hossain on 6/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"

@class HMAccessory;

@interface LHHomeKitDevice : LHDevice

@property (nonatomic, strong, readonly) HMAccessory * accessory;

- (instancetype) initWithHMAccessory:(HMAccessory *) accessory;

- (void) readPowerStateForServiceType:(NSString*) serviceType;
- (void) writePowerState:(id)targetValue
          forServiceType:(NSString*) serviceType;
@end
