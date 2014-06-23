//
//  LHHomeKitController.h
//  Lithouse
//
//  Created by Shah Hossain on 6/21/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHHomeKitDevice;
@protocol LHDeviceViewControllerDelegate;

@interface LHHomeKitController : NSObject

- (instancetype) initWithDeviceViewController : (id <LHDeviceViewControllerDelegate>) deviceViewControllerDelegate;
- (void) startSearchingForHomeKitDevices;
- (void) stopSearchingForHomeKitDevices;

- (void) pairDevice : (LHHomeKitDevice *) aDevice;
@end
