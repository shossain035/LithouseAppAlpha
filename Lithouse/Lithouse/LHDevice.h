//
//  LHDevice.h
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LHDeviceDidStatusChangeNotification;

@class LHAction;

typedef NS_ENUM ( NSUInteger, LHDeviceStatus ) {
    LHDeviceIsUnknown,
    LHDeviceIsOn,
    LHDeviceIsOff,
    LHDeviceIsUnPaired
};

@interface LHDevice : NSObject

@property (nonatomic, strong)   NSString            * friendlyName;
@property (nonatomic, strong)   UIImage             * displayImage;
@property (nonatomic)           LHDeviceStatus        currentStatus;
@property (nonatomic, readonly) NSUInteger            actionCount;

- (NSString *) identifier;

- (void) addToPermissibleActions : (LHAction *) anAction;
- (LHAction *) actionForActionId : (NSString *) actionId;
- (LHAction *) actionAtIndex     : (long) index;

- (void) toggle;
- (void) notifyCurrentStatus;
+ (UIImage *) imageForStatus : (LHDeviceStatus) status;
@end
