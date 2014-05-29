//
//  LHWeMoSwitch.m
//  Lithouse
//
//  Created by Shah Hossain on 5/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHWeMoSwitch.h"

@implementation LHWeMoSwitch

- (id) init
{
    if ( self = [super init] ) {
        //[self addToPermissibleActions : [[LHToggle alloc] initWithParentDevice : self]];
        [self addToPermissibleActions : [[LHTurnOff alloc] initWithParentDevice : self]];
        [self addToPermissibleActions : [[LHTurnOn alloc] initWithParentDevice : self]];
    }
    
    return self;
}

- (id) initWithWeMoControlDevice : (WeMoControlDevice *) aWeMoControlDevice
{
    if ( self = [self init] ) {
        [self updateWithWeMoControlDevice : aWeMoControlDevice];
    }
    
    return self;
}

- (void) updateWithWeMoControlDevice : (WeMoControlDevice *) aWeMoControlDevice
{
    self.weMoControlDevice = aWeMoControlDevice;
    self.friendlyName = aWeMoControlDevice.friendlyName;
    self.displayImage = [self defaultDeviceIcon : aWeMoControlDevice.deviceType];
    
    if ( self.weMoControlDevice.state == WeMoDeviceOn ) {
        self.currentStatus = LHDeviceIsOn;
    } else {
        self.currentStatus = LHDeviceIsOff;
    }
}


- (UIImage*) defaultDeviceIcon : (NSInteger) deviceType
{
    switch (deviceType) {
        case 0:
            return [UIImage imageNamed:@"ic_switch"];
            
        case 1:
            return [UIImage imageNamed:@"ic_sensor"];
            
        case 2:
            return [UIImage imageNamed:@"ic_insight"];
            
        case 3:
            return [UIImage imageNamed:@"ic_wallpaper"];
            
    }
    
    return nil;
}

- (void) turnOn
{
    self.currentStatus = LHDeviceIsOn;
    NSLog ( @"turning wemo on");
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self.weMoControlDevice setPluginStatus : WeMoDeviceOn];
    });
}

- (void) turnOff
{
    self.currentStatus = LHDeviceIsOff;
    NSLog ( @"turning wemo off");
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self.weMoControlDevice setPluginStatus : WeMoDeviceOff];
    });
}

- (void) toggle
{
    NSLog ( @"toggling wemo");
    
    if ( self.weMoControlDevice.state == WeMoDeviceOn ) {
        [self turnOff];
    } else {
        [self turnOn];
    }
}

- (NSString *) identifier
{
    return self.weMoControlDevice.udn;
}


@end
