//
//  DeviceProtocols.h
//  Lithouse
//
//  Created by Shah Hossain on 6/14/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#ifndef Lithouse_DeviceProtocols_h
#define Lithouse_DeviceProtocols_h

typedef NS_ENUM ( NSUInteger, LHThermostatState ) {
    LHThermostatOff,
    LHThermostatHeating,
    LHThermostatCooling,
    LHThermostatAuto,
};

typedef struct _LHCharacteristicRange {
    double maximumValue;
    double minimumValue;
} LHCharacteristicRange;


NS_INLINE LHCharacteristicRange LHMakeRange(double minimumValue, double maximumValue) {
    LHCharacteristicRange r;
    r.minimumValue = minimumValue;
    r.maximumValue = maximumValue;
    return r;
}

@protocol LHSchedule;

@protocol LHDeviceDetailChanging <NSObject>

@end

@protocol LHScheduleing <NSObject>
- (id<LHSchedule>) createSchedule;
- (void) saveSchedule : (id<LHSchedule>) schedule;
- (void) removeSchedule : (id<LHSchedule>) schedule;
- (NSArray *) getSchedules;
- (void) enableSchedule : (id<LHSchedule>) schedule;
@end

@protocol LHLightColorChanging <LHDeviceDetailChanging>

- (void) updateColor : (UIColor *) toColor;
- (UIColor *) getCurrentColor;
- (BOOL) doesSupportColorControl;

@end

@protocol LHThermostatSetting <LHDeviceDetailChanging>

- (void) updateTargetTemperature:(NSNumber *) targetTemperature;
- (NSNumber *) getTargetTemperature;
- (NSNumber *) getCurrentTemperature;
- (LHCharacteristicRange) getTemperatureRange;
- (void) updateTargetState:(LHThermostatState) targetState;
- (LHThermostatState) getCurrentState;

@end


#endif
