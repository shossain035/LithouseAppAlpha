//
//  LHDevice.h
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHToggle.h"

extern NSString * const LHDeviceDidStatusChangeNotification;

typedef NS_ENUM ( NSUInteger, LHDeviceStatus ) {
    LHDeviceIsUnknown,
    LHDeviceIsOn,
    LHDeviceIsOff
};

@interface LHDevice : NSObject <LHToogleHandler>

@property (nonatomic, strong) NSString            * friendlyName;
@property (nonatomic, strong) UIImage             * displayImage;
@property (nonatomic, strong) NSMutableDictionary * permissibleActions;
@property (nonatomic)         LHDeviceStatus        currentStatus;

- (NSString *) identifier;
- (void) addToPermissibleActions : (LHAction *) aAction;
- (void) notifyCurrentStatus;
@end
