//
//  LHDeviceCell.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDeviceCell.h"

@interface LHDeviceCell ()
@property (strong, nonatomic) id statusChangeObserver;
@end

@implementation LHDeviceCell


- (IBAction) infoButtonTapped : (id) sender
{
    NSLog ( @"info button tapped" );
    self.infoButtonCallback();
}

- (void) addObserverForDevice : (LHDevice *) aDevice
{
    [[NSNotificationCenter defaultCenter] removeObserver : self.statusChangeObserver];
    
    self.statusChangeObserver = [[NSNotificationCenter defaultCenter]
        addObserverForName : LHDeviceDidStatusChangeNotification
        object             : aDevice
        queue              : [NSOperationQueue mainQueue]
        usingBlock         : ^ (NSNotification * notification)
        {
            NSDictionary * statusData = notification.userInfo;
            self.backgroundColor = [UIColor whiteColor];
            
            if ( [[statusData objectForKey : LHDeviceDidStatusChangeNotification]
                  intValue] == LHDeviceIsOn ) {
                self.nameLabel.textColor = [UIColor darkGrayColor];
                self.backgroundColor = [UIColor colorWithRed : 0.74991234038415455f
                                                       green : 1.0f
                                                        blue : 0.78419363416042009f
                                                       alpha : 1.0f];
                
            } else if ( [[statusData objectForKey : LHDeviceDidStatusChangeNotification]
                         intValue] == LHDeviceIsOff ) {
                self.nameLabel.textColor = [UIColor grayColor];
            } else if ( [[statusData objectForKey : LHDeviceDidStatusChangeNotification]
                         intValue] == LHDeviceIsUnknown ) {
                self.nameLabel.textColor = [UIColor greenColor];
            }
        }
    ];
    
    [aDevice notifyCurrentStatus];
}

- (void) animate
{
    self.layer.borderColor = [[UIColor greenColor] CGColor];
    
    CABasicAnimation * borderAnimation = [CABasicAnimation animationWithKeyPath : @"borderWidth"];
    [borderAnimation setFromValue : [NSNumber numberWithFloat : 1.0f]];
    [borderAnimation setToValue : [NSNumber numberWithFloat : 0.0f]];
    [borderAnimation setRepeatCount : 2.0];
    [borderAnimation setAutoreverses : NO];
    [borderAnimation setDuration : 0.5f];
    
    [self.layer addAnimation : borderAnimation forKey : @"animateBorder"];
}

@end
