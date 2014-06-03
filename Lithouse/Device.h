//
//  Device.h
//  Lithouse
//
//  Created by Shah Hossain on 6/2/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LHDevice.h"


@interface Device : NSManagedObject

@property (nonatomic, retain) NSString * ssid;
@property (nonatomic, retain) NSData   * lhDeviceData;
@property (nonatomic, retain) LHDevice * lhDevice;

@end
