//
//  LHDeviceCell.h
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHCollectionViewCell.h"

@class LHDevice;
@interface LHDeviceCell : LHCollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView   * image;
@property (strong, nonatomic) IBOutlet UILabel       * nameLabel;
@property (strong, nonatomic) IBOutlet UIButton      * infoButton;

- (void) addObserverForDevice : (LHDevice *) aDevice;

@end
