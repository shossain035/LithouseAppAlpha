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
    
    [self configureCellWithDevice:aDevice];
    
    self.statusChangeObserver = [[NSNotificationCenter defaultCenter]
        addObserverForName : LHDeviceDidStatusChangeNotification
        object             : aDevice
        queue              : [NSOperationQueue mainQueue]
        usingBlock         : ^ (NSNotification * notification)
        {
            [self configureCellWithDevice:aDevice];
        }
    ];
}

- (void) configureCellWithDevice:(LHDevice *) aDevice
{
    self.image.image = [aDevice imageForStatus:aDevice.currentStatus];
    if (self.image.image == nil) {
        self.image.image = aDevice.displayImage;
    }
    
    [self activate:NO];
    if ( aDevice.currentStatus == LHDeviceIsOn ) {
        [self activate:YES];
    } else if ( aDevice.currentStatus == LHDeviceIsUnPaired ) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.statusChangeObserver];
}

@end
