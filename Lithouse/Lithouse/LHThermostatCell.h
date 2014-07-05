//
//  LHThermostatCell.h
//  Lithouse
//
//  Created by Shah Hossain on 7/2/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHThermostatSetting;

@interface LHThermostatCell : UICollectionViewCell

- (void) configureWithThermostat:(id<LHThermostatSetting>) thermostat;
- (void) refresh;
@end
