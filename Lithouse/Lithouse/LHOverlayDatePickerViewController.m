//
//  LHOverlayDatePickerViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 7/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHOverlayDatePickerViewController.h"

@interface LHOverlayDatePickerViewController ()
{
    NSDate * _selectedDate;
}

@property (nonatomic, strong) IBOutlet UIDatePicker * datePicker;
@property (copy) LHDidSelectDateCallback              didSelectDateCallback;

@end

@implementation LHOverlayDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.date = _selectedDate;
}

- (void) setupOverlayDatePickerViewWithDate:(NSDate *) date
                  withDidSelectDateCallback:(LHDidSelectDateCallback) didSelectDateCallback
{
    _selectedDate = date;
    self.didSelectDateCallback = didSelectDateCallback;
}

- (IBAction) datePickerValueChanged:(id)sender
{
    _selectedDate = self.datePicker.date;
    self.didSelectDateCallback(_selectedDate);
}

@end
