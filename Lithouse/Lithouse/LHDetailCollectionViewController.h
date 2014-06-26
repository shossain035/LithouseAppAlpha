//
//  LHDetailCollectionViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 6/24/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHDeviceDetailChanging;

@interface LHDetailCollectionViewController : UICollectionViewController

@property (nonatomic, weak) id <LHDeviceDetailChanging> device;

@end
