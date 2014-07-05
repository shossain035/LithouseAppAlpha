//
//  LHThermostatCell.m
//  Lithouse
//
//  Created by Shah Hossain on 7/2/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHThermostatCell.h"
#import "EFCircularSlider.h"
#import "DeviceProtocols.h"

@interface LHThermostatCell ()
@property (nonatomic, strong) IBOutlet EFCircularSlider  * temperatureSlider;
@property (nonatomic, strong) IBOutlet UILabel           * currentTemperatureLabel;
@property (nonatomic, strong) IBOutlet UILabel           * currentStateLabel;
@property (nonatomic, strong) id<LHThermostatSetting>      thermostat;
@end

@implementation LHThermostatCell

- (void)awakeFromNib
{
    self.temperatureSlider.lineWidth = 10;
    self.temperatureSlider.handleType = EFBigCircle;
    self.temperatureSlider.filledColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    
    [self.temperatureSlider addTarget:self action:@selector(valueChanged:)
                     forControlEvents:UIControlEventValueChanged];
    
}

-(void)valueChanged:(EFCircularSlider*)slider {
    NSLog (@"%.02f", slider.currentValue);
    
    [self.thermostat updateTargetTemperature:@(slider.currentValue)];
}

- (void) configureWithThermostat:(id<LHThermostatSetting>) thermostat
{
    self.thermostat = thermostat;
    LHCharacteristicRange temperatureRange = [thermostat getTemperatureRange];
    self.temperatureSlider.minimumValue = temperatureRange.minimumValue;
    self.temperatureSlider.maximumValue = temperatureRange.maximumValue;
    self.temperatureSlider.currentValue = [[self.thermostat getTargetTemperature] doubleValue];
}

- (void) refresh
{
    self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%d",
                                         [[self.thermostat getCurrentTemperature] integerValue]];
    
    switch ([self.thermostat getCurrentState]) {
        case LHThermostatOff:
            self.currentStateLabel.text = @"Off";
            break;
        case LHThermostatAuto:
            self.currentStateLabel.text = @"Auto";
            break;
        case LHThermostatCooling:
            self.currentStateLabel.text = @"Cooling";
            break;
        case LHThermostatHeating:
            self.currentStateLabel.text = @"Heating";
            break;
        default:
            self.currentStateLabel.text = @"";
            break;
    }
}

@end
