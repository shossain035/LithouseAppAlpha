//
//  LHGroupCRUDViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceGroup.h"

@interface LHGroupCRUDViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

- (void) initializeWithDevices : (NSMutableArray *) devices
               withDeviceGroup : (DeviceGroup *) deviceGroup
                    isNewGroup : (BOOL) isNewGroup;

@end
