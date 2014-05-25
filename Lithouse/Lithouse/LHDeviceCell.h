//
//  LHDeviceCell.h
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHDevice.h"

typedef void (^LHDeviceCellInfoButtonCallbackBlock) (void);
typedef void (^LHDeviceCellToggleCallbackBlock)     (void);

@interface LHDeviceCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView   * image;
@property (strong, nonatomic) IBOutlet UILabel       * nameLabel;
@property (copy) LHDeviceCellInfoButtonCallbackBlock   infoButtonCallback;
@property (copy) LHDeviceCellToggleCallbackBlock       toggleCallbackBlock;

- (void) addObserverForDevice : (LHDevice *) aDevice;
@end
