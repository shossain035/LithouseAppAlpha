//
//  LHGroupCRUDViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHGroupCRUDViewController.h"
#import "LHGroupDeviceTableViewCell.h"
#import "LHModalPickerViewController.h"
#import "LHAppDelegate.h"

#import "LHDevice.h"
#import "LHAction.h"
#import "LHAlertView.h"

@interface LHGroupCRUDViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray * devices;
@property (nonatomic, strong) DeviceGroup    * deviceGroup;
@property (nonatomic)         BOOL             isNewGroup;

@property (nonatomic, strong) IBOutlet UITableView * deviceTableView;
@property (nonatomic, strong) IBOutlet UITextField * groupNameField;
@property (nonatomic, strong) IBOutlet UIImageView * displayImage;
@property (nonatomic, strong) IBOutlet UIButton    * deleteButton;

@property (nonatomic, strong) NSMutableDictionary  * currentActionsForDevices;
@property (nonatomic, strong) NSMutableDictionary  * selectedActionsForDevices;

@end

@implementation LHGroupCRUDViewController

- (IBAction) cancel : (id) sender
{
    NSLog( @"Cancel clicked" );
    
    if ( self.isNewGroup ) {
        LHAppDelegate * appDelegate = (LHAppDelegate *) [[UIApplication sharedApplication] delegate];

        [appDelegate.managedObjectContext deleteObject : self.deviceGroup];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) save : (id) sender
{
    NSLog( @"Save clicked" );
    //todo: error check
    
    self.deviceGroup.name = self.groupNameField.text;
    self.deviceGroup.image = UIImagePNGRepresentation ( self.displayImage.image );
    
    self.deviceGroup.actions = self.selectedActionsForDevices;
    
    LHAppDelegate * appDelegate = (LHAppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) delete : (id) sender
{
    LHAlertView *alert = [[LHAlertView alloc] initWithTitle : @"Deleting Group"
                                                    message : [NSString stringWithFormat
                                                               : @"Do you really want to delete \"%@\"?",
                                                               self.groupNameField.text]
                                          cancelButtonTitle : @"Cancel"
                                          otherButtonTitles : @[@"Delete"]];
    
    alert.completion = ^ (BOOL cancelled, NSInteger buttonIndex) {
        if ( !cancelled ) {
            LHAppDelegate * appDelegate = (LHAppDelegate *) [[UIApplication sharedApplication] delegate];
            [appDelegate.managedObjectContext deleteObject : self.deviceGroup];
            [appDelegate saveContext];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    [alert show];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGestureRecognizer * tapper = [[UITapGestureRecognizer alloc]
                                    initWithTarget : self
                                    action : @selector(handleSingleTap:)];
    
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer : tapper];
    self.groupNameField.delegate = self;
    
    self.currentActionsForDevices = [[NSMutableDictionary alloc] init];
    self.deviceTableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
}

- (void) initializeWithDevices : (NSMutableArray *) devices
               withDeviceGroup : (DeviceGroup *) deviceGroup
                    isNewGroup : (BOOL) isNewGroup
{
    self.isNewGroup = isNewGroup;
    self.devices = devices;
    self.deviceGroup = deviceGroup;
    [self.currentActionsForDevices removeAllObjects];
    self.selectedActionsForDevices = [[NSMutableDictionary alloc] init];
    
    for ( NSString * deviceId in deviceGroup.actions ) {
        [self.selectedActionsForDevices setObject : [deviceGroup.actions objectForKey : deviceId]
                                           forKey : deviceId];
    }
        
    //select default action for all devices
    if ( self.isNewGroup ) {
        for ( int i =0; i< devices.count; i++  ) {
            LHDevice * device = devices[i];
            LHAction * action = [[device.permissibleActions allValues] objectAtIndex : 0];
            [self.selectedActionsForDevices setObject : action.identifier
                                               forKey : device.identifier];

        }
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    self.displayImage.image = [UIImage imageWithData : self.deviceGroup.image];
    self.groupNameField.text = self.deviceGroup.name;
    
    if ( !self.isNewGroup ) {
        self.title = self.deviceGroup.name;
        self.deleteButton.hidden = NO;
    } else {
        self.title = @"Create Group";
        self.deleteButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView : (UITableView *) tableView
{
    return 1;
}

- (NSInteger) tableView : (UITableView *) tableView
  numberOfRowsInSection : (NSInteger) section
{
    return [self.devices count];
}


 - (UITableViewCell *) tableView : (UITableView *) tableView
           cellForRowAtIndexPath : (NSIndexPath *) indexPath
{
    LHGroupDeviceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier : @"GroupDeviceCell"
                                                                         forIndexPath : indexPath];
    LHGroupDeviceTableViewCell * __weak wCell = cell;
    LHDevice * device = [self.devices objectAtIndex : indexPath.row];
    
    cell.actionPickerCallback = ^{
        [self launchActionPickerForCell : wCell withDevice : device];
    };
    
    cell.selectionButtonCallback = ^ (BOOL isSelected) {
        if ( isSelected ) {
            
            [self.selectedActionsForDevices setObject : [self.currentActionsForDevices objectForKey : device.identifier]
                                               forKey : device.identifier];
        } else {
            [self.selectedActionsForDevices removeObjectForKey : device.identifier];
        }
    };

    LHAction * action = [device.permissibleActions objectForKey :
                         [self.selectedActionsForDevices objectForKey : device.identifier]];
     
    BOOL selectionFlag = YES;
    if ( action == nil ) {
        action = [[device.permissibleActions allValues] objectAtIndex : 0];
        selectionFlag = NO;
    }
    
    [self updateCurrentActionForDevice : device
                            withAction : action
                        forDisplayCell : cell
                            isSelected : selectionFlag];

    [cell.deviceNameButton setTitle : device.friendlyName
                           forState : UIControlStateNormal];
    
    return cell;
}

- (void) launchActionPickerForCell : (LHGroupDeviceTableViewCell *) deviceSelectionCell
                        withDevice : (LHDevice *) aDevice
{
    UINavigationController * navigationController = (UINavigationController *)
        [self.storyboard instantiateViewControllerWithIdentifier : @"ModalPickerViewController"];

    LHModalPickerViewController * pickerViewController =
        (LHModalPickerViewController *) [[navigationController viewControllers] objectAtIndex : 0];
    pickerViewController.navigationItem.title = aDevice.friendlyName;
    
    pickerViewController.numberOfRowsCallback = ^ NSInteger {
        return [aDevice.permissibleActions count];
    };

    pickerViewController.updateCellAtIndexPathCallback =
    ^ (UITableViewCell * cell, NSIndexPath * indexPath) {
        LHAction * action = [[aDevice.permissibleActions allValues] objectAtIndex : indexPath.row];
        cell.textLabel.text = action.friendlyName;
        
        if ([self isSelectedAction : action forDevice : aDevice]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    };
    
    pickerViewController.didSelectRowAtIndexPathCallback = ^ (NSIndexPath * indexPath) {
        LHAction * action = [[aDevice.permissibleActions allValues] objectAtIndex : indexPath.row];
        [self updateCurrentActionForDevice : aDevice
                                withAction : action
                            forDisplayCell : deviceSelectionCell
                                isSelected : YES];
    };
    
    [self presentViewController : navigationController animated : YES completion : nil];
}

- (void) updateCurrentActionForDevice : (LHDevice *) aDevice
                           withAction : (LHAction *) anAction
                       forDisplayCell : (LHGroupDeviceTableViewCell *) aCell
                           isSelected : (BOOL) selectionFlag
{
    [self.currentActionsForDevices setObject : anAction.identifier
                                      forKey : aDevice.identifier];
    
    [aCell.actionPickerButton setTitle : anAction.friendlyName
                             forState : UIControlStateNormal];
    [aCell selectDevice : selectionFlag];
}

- (BOOL) isSelectedAction : (LHAction *) anAction
                forDevice : (LHDevice *) forDevice
{
    if ([anAction.identifier isEqualToString :
         [self.currentActionsForDevices objectForKey : forDevice.identifier]]) {
        return YES;
    }
    
    return NO;
}

#pragma mark gesture recognizer
- (void) handleSingleTap : (UITapGestureRecognizer *) sender
{
    [self.groupNameField resignFirstResponder];
}

#pragma mark textfield delegate
- (BOOL) textFieldShouldReturn : (UITextField *) textField {
    if ( textField == self.groupNameField ) {
        [textField resignFirstResponder];
    }
    return NO;
}
@end
