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

@interface LHGroupCRUDViewController ()

@property (nonatomic, strong) NSMutableArray * devices;
@property (nonatomic, strong) DeviceGroup    * deviceGroup;
@property (nonatomic)         BOOL             isNewGroup;

@property (nonatomic, strong) IBOutlet UITableView * deviceTableView;
@property (nonatomic, strong) IBOutlet UITextField * groupNameField;
@property (nonatomic, strong) IBOutlet UIImageView * displayImage;

@property (nonatomic, strong) NSMutableDictionary  * currentActionsForDevices;

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
    //self.deviceGroup.image =
    
    LHAppDelegate * appDelegate = (LHAppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
}

- (void) viewWillAppear:(BOOL)animated
{
    self.displayImage.image = [UIImage imageWithData : self.deviceGroup.image];
    self.groupNameField.text = self.deviceGroup.name;
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
            if ( self.deviceGroup.actions == nil ) {
                self.deviceGroup.actions = [[NSMutableDictionary alloc] init];
            }
            [self.deviceGroup.actions setObject : [self.currentActionsForDevices objectForKey : device.identifier]
                                         forKey : device.identifier];
        } else {
            [self.deviceGroup.actions removeObjectForKey : device.identifier];
        }
    };

    LHAction * action = [device.permissibleActions objectForKey :
                         [self.deviceGroup.actions objectForKey : device.identifier]];
     
    BOOL selectionFlag = YES;
    if ( action == nil ) {
        action = [[device.permissibleActions allValues] objectAtIndex : 0];
        selectionFlag = NO;
    }
    
    [self updateCurrentActionForDevice : device
                            withAction : action
                        forDisplayCell : cell
                            isSelected : selectionFlag];

    cell.deviceNameLabel.text = device.friendlyName;
    
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


@end
