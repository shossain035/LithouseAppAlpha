//
//  Device.m
//  Lithouse
//
//  Created by Shah Hossain on 6/2/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "Device.h"


@implementation Device
@dynamic ssid;
//todo: sort string const.

@dynamic lhDeviceData;

- (LHDevice *) lhDevice {
    
    [self willAccessValueForKey : @"lhDevice"];
    LHDevice * lhDevice = [self primitiveValueForKey : @"lhDevice"];
    [self didAccessValueForKey : @"lhDevice"];
    
    if ( lhDevice == nil ) {
        NSData * lhDeviceData = [self lhDeviceData];
        if ( lhDeviceData != nil ) {
            lhDevice = [NSKeyedUnarchiver unarchiveObjectWithData : lhDeviceData];
        }
    }
    
    return lhDevice;
}

- (void) setLhDevice : (LHDevice *) lhDevice {
    
    [self willChangeValueForKey : @"lhDevice"];
    [self setPrimitiveValue : lhDevice
                     forKey : @"lhDevice"];
    [self didChangeValueForKey : @"lhDevice"];
    
    [self setValue : [NSKeyedArchiver archivedDataWithRootObject : lhDevice]
            forKey : @"lhDeviceData"];
}

@end
