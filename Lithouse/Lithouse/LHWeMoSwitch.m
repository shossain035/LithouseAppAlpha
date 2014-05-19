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
        [self.permissibleActions addObject : [[LHTurnOn alloc] initWithParentDevice : self]];
        [self.permissibleActions addObject : [[LHTurnOff alloc] initWithParentDevice : self]];
    }
    
    return self;
}

- (id) initWithWeMoControlDevice : (WeMoControlDevice *) aWeMoControlDevice
{
    if ( self = [self init] ) {
        self.weMoControlDevice = aWeMoControlDevice;
        self.friendlyName = aWeMoControlDevice.friendlyName;
        
        if (aWeMoControlDevice.icon == nil) {
            self.displayImage = [self defaultDeviceIcon : aWeMoControlDevice.deviceType];
        }
        else {
            self.displayImage = aWeMoControlDevice.icon;
        }
        
    }
    
    return self;
}

- (UIImage*) defaultDeviceIcon : (NSInteger) deviceType
{
    switch (deviceType) {
        case 0:
            return [UIImage imageNamed:@"ic_switch.png"];
            
        case 1:
            return [UIImage imageNamed:@"ic_sensor.png"];
            
        case 2:
            return [UIImage imageNamed:@"ic_insight.png"];
            
        case 3:
            return [UIImage imageNamed:@"ic_wallpaper.png"];
            
    }
    
    return nil;
}


- (void) turnOn
{
    NSLog ( @"turning wemo on");
}

- (void) turnOff
{
    NSLog ( @"turning wemo off");
}


@end
