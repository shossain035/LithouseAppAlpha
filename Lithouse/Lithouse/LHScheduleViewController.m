//
//  LHScheduleViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 6/26/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHScheduleViewController.h"
#import "LHSchedule.h"
#import "LHAlertView.h"
#import "LHDevice.h"
#import "LHAction.h"

@interface LHScheduleViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) IBOutlet UIDatePicker * datePicker;
@property (nonatomic, strong) IBOutlet UIView       * datePickerContainer;
@property (nonatomic, strong) IBOutlet UIPickerView * actionPicker;
@property (nonatomic, strong) IBOutlet UIView       * actionPickerContainer;
@property (nonatomic, strong) IBOutlet UIButton     * deleteButton;


@end

@implementation LHScheduleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isNewSchedule) {
        self.deleteButton.hidden = true;
    } else {
        self.deleteButton.hidden = false;
    }

}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self hideAllPickerViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction) cancel : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) save : (id) sender
{
    [self.schedule save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) delete : (id) sender
{
    LHAlertView *alert = [[LHAlertView alloc] initWithTitle : @"Deleting Schedule"
                                                    message : [NSString stringWithFormat
                                                               : @"Do you really want to delete?"]
                                          cancelButtonTitle : @"Cancel"
                                          otherButtonTitles : @[@"Delete"]];
    
    alert.completion = ^ (BOOL cancelled, NSInteger buttonIndex) {
        if ( !cancelled ) {
            [self.schedule remove];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [alert show];
}

- (IBAction) showDatePicker : (id) sender
{
    [self pickerView:self.datePickerContainer shouldAppear:YES];
}

- (IBAction) hideDatePicker : (id) sender
{
    [self pickerView:self.datePickerContainer shouldAppear:NO];
}

- (IBAction) showActionPicker : (id) sender
{
    [self pickerView:self.actionPickerContainer shouldAppear:YES];
}

- (IBAction) hideActionPicker : (id) sender
{
    [self pickerView:self.actionPickerContainer shouldAppear:NO];
}

- (IBAction) datePickerValueChanged:(id)sender
{
    NSLog(@"time: %@", self.datePicker.date);
}

- (void) pickerView : (UIView *) pickerView
       shouldAppear : (BOOL) doesAppear
{
    CGFloat targetY = self.view.frame.size.height;
    if (doesAppear) {
        targetY -= pickerView.frame.size.height;
        [self hideAllPickerViews];
    }
    
    [UIView beginAnimations:nil context:NULL];
    pickerView.frame = CGRectMake(0.0f, targetY, pickerView.frame.size.width, pickerView.frame.size.height);
    [UIView commitAnimations];
    
}

- (void) hideAllPickerViews
{
    self.datePickerContainer.frame = CGRectMake(0.0f, self.view.frame.size.height,
                                                self.datePickerContainer.frame.size.width,
                                                self.datePickerContainer.frame.size.height);
    self.actionPickerContainer.frame = CGRectMake(0.0f, self.view.frame.size.height,
                                                  self.actionPickerContainer.frame.size.width,
                                                  self.actionPickerContainer.frame.size.height);
}

#pragma mark <UIPickerViewDataSource>
 - (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
{
    return self.device.actionCount;
}

- (NSString *) pickerView:(UIPickerView *)pickerView
              titleForRow:(NSInteger)row
             forComponent:(NSInteger)component
{
    return [self.device actionAtIndex:row].friendlyName;
}

#pragma mark <UIPickerViewDelegate>
- (void) pickerView:(UIPickerView *)pickerView
       didSelectRow:(NSInteger)row
        inComponent:(NSInteger)component
{
    NSLog(@"selected row: %d comp %d", row, component);
}

@end
