//
//  LHDeviceCell.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDeviceCell.h"
#import "LHAppDelegate.h"
#import "LHDevice.h"

@interface LHDeviceCell ()
@property (strong, nonatomic) id statusChangeObserver;
@end

@implementation LHDeviceCell

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
            LHDeviceStatus status = [[statusData objectForKey : LHDeviceDidStatusChangeNotification]
                                     intValue];
            
            UIImage * deviceImage = [[aDevice class] imageForStatus:status];
            if ( deviceImage != nil ) {
                self.image.image = deviceImage;
            }
            
            [self activate:NO];
            if ( status == LHDeviceIsOn ) {
                [self activate:YES];
            } else if ( status == LHDeviceIsUnPaired ) {
                self.backgroundColor = [UIColor lightGrayColor];
            }
            
        }
    ];
    
    [aDevice notifyCurrentStatus];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.statusChangeObserver];
}

@end
