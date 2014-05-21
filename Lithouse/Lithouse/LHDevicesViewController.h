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


@interface LHDevicesViewController : UICollectionViewController <WeMoDeviceDiscoveryDelegate,
                                                                 PHBridgePushLinkViewControllerDelegate>


@end
