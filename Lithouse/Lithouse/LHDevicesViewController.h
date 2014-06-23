//
//  LHDevicesViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeMoDiscoveryManager.h"
#import "PHBridgePushLinkViewController.h"

@class LHDevice;

@protocol LHDeviceViewControllerDelegate <NSObject>

- (void) addDeviceToList : (LHDevice *) aDevice;
- (void) addUnPairedDevicesToList : (NSMutableArray *) devices;
- (void) removeDeviceFromList : (NSString *) withDeviceIdentifier;

@end

extern NSString * const LHSearchForDevicesNotification;

@interface LHDevicesViewController : UICollectionViewController <WeMoDeviceDiscoveryDelegate,
                                                                 PHBridgePushLinkViewControllerDelegate,
                                                                 LHDeviceViewControllerDelegate>


@end
