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
@property (nonatomic, strong) IBOutlet UIDatePicker   * datePicker;
@property (nonatomic, strong) IBOutlet UIView         * datePickerContainer;
@property (nonatomic, strong) IBOutlet UIPickerView   * actionPicker;
@property (nonatomic, strong) IBOutlet UIView         * actionPickerContainer;
@property (nonatomic, strong) IBOutlet UIPickerView   * recurrancePicker;
@property (nonatomic, strong) IBOutlet UIView         * recurrancePickerContainer;

@property (nonatomic, strong) IBOutlet UIButton       * deleteButton;
@property (nonatomic, strong)          NSMutableArray * actions;

@property (nonatomic, strong) IBOutlet UIButton       * actionButton;
@property (nonatomic, strong) IBOutlet UIButton       * dateButton;
@property (nonatomic, strong) IBOutlet UIButton       * recurranceButton;
@property (nonatomic, strong, readonly) NSDateFormatter * dateFormatter;


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
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"h:mm aaa"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //todo: show device image on background
    if (self.isNewSchedule) {
        self.deleteButton.hidden = true;
        self.title = @"Create Schedule";
    } else {
        self.deleteButton.hidden = false;
        self.title = @"Edit Schedule";
    }
    
    self.datePicker.date = self.schedule.fireDate;
    [self.dateButton setTitle:[self.dateFormatter stringFromDate:self.datePicker.date]
                     forState:UIControlStateNormal];
    
    [self.actionPicker selectRow:[self indexOfSelectedAction]
                     inComponent:0
                        animated:NO];
    [self.actionButton setTitle:[self.schedule.action friendlyName]
                       forState:UIControlStateNormal];
    
    [self.recurrancePicker selectRow:self.schedule.repeatMode
                         inComponent:0
                            animated:NO];
    [self.recurranceButton setTitle:[self nameOfRepeatMode:self.schedule.repeatMode]
                       forState:UIControlStateNormal];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self hideAllPickerViewsWithAnimation:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (int) indexOfSelectedAction
{
    self.actions = [[NSMutableArray alloc] init];
    int selectedIndex = 0;
    //ignoring i=0 "ignore" action
    for ( int i=1; i<self.device.actionCount; i++) {
        self.actions[i-1] = [self.device actionAtIndex:(long)i];
        
        if ( [self.schedule.action.identifier
              isEqualToString:[self.device actionAtIndex:(long)i].identifier]) {
            
            selectedIndex = i-1;
        }
    }
        
    return selectedIndex;
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

- (IBAction) showRecurrencePicker : (id) sender
{
    [self pickerView:self.recurrancePickerContainer shouldAppear:YES];
}

- (IBAction) hideRecurrencePicker : (id) sender
{
    [self pickerView:self.recurrancePickerContainer shouldAppear:NO];
}

- (IBAction) datePickerValueChanged:(id)sender
{
    NSLog(@"time: %@", self.datePicker.date);
    //todo: consider going back in time.
    self.schedule.fireDate = self.datePicker.date;
    
    [self.dateButton setTitle:[self.dateFormatter stringFromDate:self.datePicker.date]
                     forState:UIControlStateNormal];
}

- (void) pickerView : (UIView *) pickerView
       shouldAppear : (BOOL) doesAppear
{
    [self pickerView:pickerView
        shouldAppear:doesAppear
          isAnimated:YES];
}

- (void) pickerView : (UIView *) pickerView
       shouldAppear : (BOOL) doesAppear
         isAnimated : (BOOL) animated
{
    CGFloat targetY = self.view.frame.size.height;
    if (doesAppear) {
        targetY -= pickerView.frame.size.height;
        [self hideAllPickerViewsWithAnimation:NO];
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
    }
    pickerView.frame = CGRectMake(0.0f, targetY, pickerView.frame.size.width, pickerView.frame.size.height);
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void) hideAllPickerViewsWithAnimation : (BOOL) isAnimated
{
    [self pickerView:self.datePickerContainer shouldAppear:NO isAnimated:isAnimated];
    [self pickerView:self.actionPickerContainer shouldAppear:NO isAnimated:isAnimated];
    [self pickerView:self.recurrancePickerContainer shouldAppear:NO isAnimated:isAnimated];
}

#pragma mark <UIPickerViewDataSource>
 - (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
{
    if ( pickerView == self.actionPicker) {
        return self.actions.count;
    } else if ( pickerView == self.recurrancePicker ) {
        return LHRepeatModesCount;
    }
    
    return 0;
}

- (NSString *) pickerView:(UIPickerView *)pickerView
              titleForRow:(NSInteger)row
             forComponent:(NSInteger)component
{
    if ( pickerView == self.actionPicker) {
        return ((LHAction *)self.actions[row]).friendlyName;
    } else if ( pickerView == self.recurrancePicker ) {
        return [self nameOfRepeatMode:row];
    }
    
    return @"";
}

#pragma mark <UIPickerViewDelegate>
- (void) pickerView:(UIPickerView *)pickerView
       didSelectRow:(NSInteger)row
        inComponent:(NSInteger)component
{
    if ( pickerView == self.actionPicker) {
        self.schedule.action = self.actions[row];
        [self.actionButton setTitle:[self.schedule.action friendlyName]
                         forState:UIControlStateNormal];
    } else if ( pickerView == self.recurrancePicker ) {
        self.schedule.repeatMode = row;
        [self.recurranceButton setTitle:[self nameOfRepeatMode:self.schedule.repeatMode]
                               forState:UIControlStateNormal];
    }
}

- (NSString *) nameOfRepeatMode : (LHScheduleTimerRepeatMode) mode
{
    static dispatch_once_t pred;
    static NSDictionary * nameDictionary = nil;
    
    dispatch_once(&pred, ^{
        nameDictionary = @{@(LHRepeatNever):@"Never",
                           @(LHRepeatDaily):@"Every Day",
                           @(LHRepeatWeekly):@"Every Week"};
    });
    
    return nameDictionary [@(mode)];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideAllPickerViewsWithAnimation:YES];
}

@end
