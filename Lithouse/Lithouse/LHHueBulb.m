//
//  LHHueBulb.m
//  Lithouse
//
//  Created by Shah Hossain on 5/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHueBulb.h"

@implementation LHHueBulb

- (id) init
{
    if ( self = [super init] ) {
        //[self addToPermissibleActions : [[LHToggle alloc] initWithParentDevice : self]];
        [self addToPermissibleActions : [[LHTurnOff alloc] initWithParentDevice : self]];
        [self addToPermissibleActions : [[LHTurnOn alloc] initWithParentDevice : self]];
    }
    
    return self;
}

- (id) initWithPHLight : (PHLight *) aPHLight
{
    if ( self = [self init] ) {
        [self updateWithPHLight : aPHLight];
    }
    
    return self;
}

- (void) updateWithPHLight : (PHLight *) aPHLight;
{
    self.phLight = aPHLight;
    self.friendlyName = aPHLight.name;
    self.displayImage = [UIImage imageNamed : @"hue"];
    
    if ( [self.phLight.lightState.on boolValue] ) {
        self.currentStatus = LHDeviceIsOn;
    } else {
        self.currentStatus = LHDeviceIsOff;
    }
}

- (void) turnOn
{
    self.currentStatus = LHDeviceIsOn;
    NSLog ( @"turning hue on");
    [self turnLightOn : YES];
}

- (void) turnOff
{
    self.currentStatus = LHDeviceIsOff;
    NSLog ( @"turning hue off");
    [self turnLightOn : NO];
}

- (void) toggle
{
    NSLog ( @"toggling hue");
    
    if ( [self.phLight.lightState.on boolValue] ) {
        [self turnOff];
    } else {
        [self turnOn];
    }
}

- (void) turnLightOn : (bool) targetState
{
    
    [self.phLight.lightState setOnBool : targetState];
    
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    [bridgeSendAPI updateLightStateForId : self.phLight.identifier
                           withLighState : self.phLight.lightState
                       completionHandler : ^(NSArray *errors) {
                           if (errors != nil) {
                               NSString * message = [NSString stringWithFormat : @"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                               
                               NSLog(@"Response: %@",message);
                               //todo: deal woth error
                           }
                       }];

}

- (NSString *) identifier
{
    return self.phLight.identifier;
}


@end
