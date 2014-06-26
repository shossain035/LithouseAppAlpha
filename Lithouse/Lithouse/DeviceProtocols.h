//
//  DeviceProtocols.h
//  Lithouse
//
//  Created by Shah Hossain on 6/14/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#ifndef Lithouse_DeviceProtocols_h
#define Lithouse_DeviceProtocols_h

@protocol LHDeviceDetailChanging <NSObject>

@end
@protocol LHLightColorChanging <LHDeviceDetailChanging>

- (void) updateColor : (UIColor *) toColor;
- (UIColor *) getCurrentColor;
- (BOOL) doesSupportColorControl;

@end


#endif
