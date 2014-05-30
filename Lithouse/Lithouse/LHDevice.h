//
//  LHDevice.h
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHToggle.h"
#import "LHIgnoreAction.h"

extern NSString * const LHDeviceDidStatusChangeNotification;

typedef NS_ENUM ( NSUInteger, LHDeviceStatus ) {
    LHDeviceIsUnknown,
    LHDeviceIsOn,
    LHDeviceIsOff
};

@interface LHDevice : NSObject <LHToogleHandler,
                                LHIgnoreActionHandler>

@property (nonatomic, strong)   NSString            * friendlyName;
@property (nonatomic, strong)   UIImage             * displayImage;
@property (nonatomic)           LHDeviceStatus        currentStatus;
@property (nonatomic, readonly) int                   actionCount;

- (NSString *) identifier;

- (void) addToPermissibleActions : (LHAction *) anAction;
- (LHAction *) actionForActionId : (NSString *) actionId;
- (LHAction *) actionAtIndex     : (int) index;


- (void) notifyCurrentStatus;
@end
