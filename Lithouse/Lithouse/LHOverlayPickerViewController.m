//
//  LHOverlayPickerViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 7/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHOverlayPickerViewController.h"

@interface LHOverlayPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray  * _dataSource;
    NSString * _title;
    int        _selectedIndex;
}

@property (nonatomic, strong) IBOutlet UIPickerView   * mainPickerView;
@property (nonatomic, strong) IBOutlet UILabel        * titleLabel;

@property (copy) LHDidSelectRowCallback                 didSelectRowCallback;
@end

@implementation LHOverlayPickerViewController


- (void) setupOverlayPickerViewWithDataSource:(NSArray *) dataSource
                            withSelectedIndex:(int) selectedIndex
                                    withTitle:(NSString *) title
                     withDidSelectRowCallback:(LHDidSelectRowCallback) didSelectRowCallback
{
    _dataSource = dataSource;
    _selectedIndex = selectedIndex;
    _title = title;
    self.didSelectRowCallback = didSelectRowCallback;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mainPickerView selectRow:_selectedIndex inComponent:0 animated:NO];
    self.titleLabel.text = _title;
}

#pragma mark <UIPickerViewDataSource>
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
{
    return _dataSource.count;
}

- (NSString *) pickerView:(UIPickerView *)pickerView
              titleForRow:(NSInteger)row
             forComponent:(NSInteger)component
{
    return _dataSource[row];
}

#pragma mark <UIPickerViewDelegate>
- (void) pickerView:(UIPickerView *)pickerView
       didSelectRow:(NSInteger)row
        inComponent:(NSInteger)component
{
    _selectedIndex = row;
    self.didSelectRowCallback(row);
}



@end
