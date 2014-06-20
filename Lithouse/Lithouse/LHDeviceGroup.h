//
//  LHDeviceGroup.h
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevice.h"
@class DeviceGroup;

@interface LHDeviceGroup : LHDevice

@property (nonatomic, strong) DeviceGroup                    * managedDeviceGroup;

- (id) initWithManagedDeviceGroup : (DeviceGroup *) aManagedDeviceGroup
             withDeviceDictionary : (NSMutableDictionary *) aDeviceDictionary;

@end
