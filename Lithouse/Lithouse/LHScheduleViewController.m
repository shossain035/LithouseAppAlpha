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

#import "LHOverlayPickerViewController.h"
#import "LHOverlayDatePickerViewController.h"
#import "LHOverlayTransitioner.h"

#define kOverlayPickerViewControllerId     @"LHOverlayPickerViewController"
#define kOverlayDatePickerViewControllerId @"LHOverlayDatePickerViewController"

@interface LHScheduleViewController ()
{
    id<UIViewControllerTransitioningDelegate> _transitioningDelegate;
}


@property (nonatomic, strong) IBOutlet UIButton       * deleteButton;
@property (nonatomic, strong)          NSMutableArray * actionNames;
@property (nonatomic, strong) IBOutlet UIButton       * dateButton;
@property (nonatomic, strong, readonly) NSDateFormatter * dateFormatter;
@property (nonatomic, strong) IBOutlet UIImageView    * displayImage;
@property (nonatomic, strong) IBOutlet UILabel        * actionLabel;
@property (nonatomic, strong) IBOutlet UILabel        * recurranceLabel;
@property (nonatomic, strong) IBOutlet UILabel        * deviceNameLabel;

@end

@implementation LHScheduleViewController


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
    
    [self.dateButton setTitle:[self.dateFormatter stringFromDate:self.schedule.fireDate]
                     forState:UIControlStateNormal];
    self.actionLabel.text = [self.schedule.action friendlyName];
    self.recurranceLabel.text = stringWithLHScheduleTimerRepeatMode(self.schedule.repeatMode);
   
    //todo: image for status based on action
    self.displayImage.image = [self.device imageForStatus:LHDeviceIsOff];
    self.deviceNameLabel.text = self.device.friendlyName;
    
    self.actionNames = [[NSMutableArray alloc] init];
    //ignoring i=0 "ignore" action
    for ( int i=1; i<self.device.actionCount; i++) {
        self.actionNames[i-1] = [self.device actionAtIndex:(long)i].friendlyName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (int) indexOfSelectedAction
{
    int selectedIndex = 0;
    //ignoring i=0 "ignore" action
    for ( int i=1; i<self.device.actionCount; i++) {
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

- (void) showOverlay:(LHOverlayViewController *) overlayController
{
    _transitioningDelegate = [[LHOverlayTransitioningDelegate alloc] init];
    [overlayController setTransitioningDelegate: _transitioningDelegate];
    
    [self presentViewController:overlayController animated:YES completion:NULL];
}

- (IBAction) showActionPicker : (id) sender
{
    LHOverlayPickerViewController *overlay = [self.storyboard
                                              instantiateViewControllerWithIdentifier:kOverlayPickerViewControllerId];
    
    [overlay setupOverlayPickerViewWithDataSource:self.actionNames
                                withSelectedIndex:[self indexOfSelectedAction]
                                        withTitle:@"Select Action"
                         withDidSelectRowCallback:^(NSInteger selectedRow) {
                             //todo: cleanup mapping. related indexOfSelectedAction()
                             self.schedule.action = [self.device actionAtIndex:selectedRow + 1];
                             self.actionLabel.text = [self.schedule.action friendlyName];
                         }];
    
    [self showOverlay:overlay];
}

- (IBAction) showRecurrencePicker : (id) sender
{
    LHOverlayPickerViewController *overlay = [self.storyboard
                                        instantiateViewControllerWithIdentifier:kOverlayPickerViewControllerId];
    
    [overlay setupOverlayPickerViewWithDataSource:getRepeatModeNames()
                                withSelectedIndex:self.schedule.repeatMode
                                        withTitle:@"Repeat"
                         withDidSelectRowCallback:^(NSInteger selectedRow) {
                  self.schedule.repeatMode = selectedRow;
                  self.recurranceLabel.text
                    = stringWithLHScheduleTimerRepeatMode(self.schedule.repeatMode);
              }];
    
    [self showOverlay:overlay];
}

- (IBAction) showDatePicker:(id)sender
{
    LHOverlayDatePickerViewController *dateOverlay =
        [self.storyboard instantiateViewControllerWithIdentifier:kOverlayDatePickerViewControllerId];

    [dateOverlay setupOverlayDatePickerViewWithDate:self.schedule.fireDate
                          withDidSelectDateCallback:^(NSDate * selectedDate) {
                              self.schedule.fireDate = selectedDate;
                              [self.dateButton setTitle:[self.dateFormatter stringFromDate:self.schedule.fireDate]
                                               forState:UIControlStateNormal];
                              
                          }];
    
    [self showOverlay:dateOverlay];
}

@end
