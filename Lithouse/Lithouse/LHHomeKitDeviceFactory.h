//
//  LHHomeKitDeviceFactory.h
//  Lithouse
//
//  Created by Shah Hossain on 6/21/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHDevice;
@class HMAccessory;

@interface LHHomeKitDeviceFactory : NSObject
+ (LHDevice *) newHomeKitDeviceWithAccessory : (HMAccessory *) accessory;

@end
