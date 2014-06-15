//
//  LHHueBulb.m
//  Lithouse
//
//  Created by Shah Hossain on 5/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHueBulb.h"

//throttling timeout for Hue api call in seconds
static int const LHHueApiCallInterval = 1.0;

@implementation LHHueBulb

- (id) init
{
    if ( self = [super init] ) {
        //[self addToPermissibleActions : [[LHToggle alloc] initWithParentDevice : self]];
        [self addToPermissibleActions : [[LHTurnOn alloc] initWithParentDevice : self]];
        [self addToPermissibleActions : [[LHTurnOff alloc] initWithParentDevice : self]];
    }
    
    return self;
}

- (id) initWithPHLight : (PHLight *) aPHLight
{
    if ( self = [self init] ) {
        [self updateWithPHLight : aPHLight];
    }
    self.displayImage = [UIImage imageNamed : @"hue"];
    
    return self;
}

- (void) updateWithPHLight : (PHLight *) aPHLight;
{
    self.phLight = aPHLight;
    self.friendlyName = aPHLight.name;
    
    
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
    
    [self updateLightState];
}

- (void) updateColor : (UIColor *) toColor
{
    self.currentStatus = LHDeviceIsOn;
    
    CGFloat hue, saturation, brightness, alpha;
    
    [toColor getHue:&hue
         saturation:&saturation
         brightness:&brightness
              alpha:&alpha];
    
    [self.phLight.lightState setOnBool : true];
    
    CGPoint xyPoint = [PHUtilities calculateXY:toColor forModel:self.phLight.modelNumber];
    //[self.phLight.lightState setHue:@((int)(hue * 65535.0))];
    //[self.phLight.lightState setSaturation:@((int)(saturation * 254.0))];
    [self.phLight.lightState setX:@(xyPoint.x)];
    [self.phLight.lightState setY:@(xyPoint.y)];
    
    [self.phLight.lightState setBrightness:@((int)(brightness * 254.0))];
    
    [self updateLightState];
}

-(UIColor *) getCurrentColor
{
    UIColor * currentColor = [PHUtilities colorFromXY:CGPointMake([self.phLight.lightState.x floatValue],
                                                                  [self.phLight.lightState.y floatValue])
                                             forModel:self.phLight.modelNumber];
    
    return currentColor;
    
}

- (NSString *) identifier
{
    return self.phLight.identifier;
}


- (void) updateLightState
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_semaphore_wait([LHHueBulb sharedSemaphore], DISPATCH_TIME_FOREVER);
        
        //throttling
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSTimer scheduledTimerWithTimeInterval:LHHueApiCallInterval
                                             target:[LHHueBulb class]
                                           selector:@selector(signalSharedSemaphore:)
                                           userInfo:nil
                                            repeats:NO];
        });
        
        id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
        
        // Send lightstate to light
        [bridgeSendAPI updateLightStateForId:self.phLight.identifier
                               withLighState:self.phLight.lightState
                           completionHandler:^(NSArray *errors) {
                               if (errors != nil) {
                                   NSLog(@"Response: %@",errors);
                               }
        }];
    });

}

+ (void) signalSharedSemaphore:(NSTimer *)timer
{
    dispatch_semaphore_signal([LHHueBulb sharedSemaphore]);
}

+ (dispatch_semaphore_t) sharedSemaphore
{
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t sharedSemaphore;
    
    dispatch_once(&onceToken, ^{
        sharedSemaphore = dispatch_semaphore_create(1);
    });
    
    return sharedSemaphore;
}

@end
