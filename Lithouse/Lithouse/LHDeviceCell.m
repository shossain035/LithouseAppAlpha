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
            
            if ( [[statusData objectForKey : LHDeviceDidStatusChangeNotification]
                  intValue] == LHDeviceIsOn ) {
                self.nameLabel.textColor = [UIColor greenColor];
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

@end
