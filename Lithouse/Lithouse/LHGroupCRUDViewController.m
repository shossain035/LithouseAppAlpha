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

#import "LHDevice.h"
#import "LHAction.h"

@interface LHGroupCRUDViewController ()

@property (nonatomic, strong) IBOutlet UITableView * deviceTableView;

@end

@implementation LHGroupCRUDViewController

- (IBAction) cancel : (id) sender
{
    NSLog( @"Cancel clicked" );
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) save : (id) sender
{
    NSLog( @"Save clicked" );
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
    
     self.deviceTableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
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
     cell.deviceNameLabel.text = device.friendlyName;
     
     cell.actionPickerCallback = ^{
         [self launchActionPickerForCell : wCell withDevice : device];
     };

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
        LHAction * action = [aDevice.permissibleActions objectAtIndex : indexPath.row];
        cell.textLabel.text = action.friendlyName;
    };
    
    pickerViewController.didSelectRowAtIndexPathCallback = ^ (NSIndexPath * indexPath) {
        LHAction * action = [aDevice.permissibleActions objectAtIndex : indexPath.row];
        [deviceSelectionCell.actionPickerButton setTitle : action.friendlyName
                                                forState : UIControlStateNormal];
    };
    
    [self presentViewController : navigationController animated : YES completion : nil];
}


@end
