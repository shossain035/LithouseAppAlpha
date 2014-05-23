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
        [self addToPermessibleActions : [[LHToggle alloc] initWithParentDevice : self]];
        [self addToPermessibleActions : [[LHTurnOff alloc] initWithParentDevice : self]];
        [self addToPermessibleActions : [[LHTurnOn alloc] initWithParentDevice : self]];
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
    [self.weMoControlDevice setPluginStatus : WeMoDeviceOn];
}

- (void) turnOff
{
    NSLog ( @"turning wemo off");
    [self.weMoControlDevice setPluginStatus : WeMoDeviceOff];
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
