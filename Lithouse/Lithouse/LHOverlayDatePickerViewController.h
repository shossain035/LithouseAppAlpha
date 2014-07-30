//
//  LHOverlayDatePickerViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 7/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHOverlayViewController.h"

typedef void (^LHDidSelectDateCallback) (NSDate * selectedDate);

@interface LHOverlayDatePickerViewController : LHOverlayViewController

- (void) setupOverlayDatePickerViewWithDate:(NSDate *) date
                  withDidSelectDateCallback:(LHDidSelectDateCallback) didSelectDateCallback;

@end
