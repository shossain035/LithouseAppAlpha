//
//  LHColorPickerViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 6/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceProtocols.h"

@interface LHColorPickerViewController : UIViewController

@property (nonatomic, strong) id <ColoredLight> light;

@end
