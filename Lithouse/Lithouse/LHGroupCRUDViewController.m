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
#import <MobileCoreServices/MobileCoreServices.h>

int const LHPhotoPickerActionSheetTag = 1;

@interface LHGroupCRUDViewController () <UITextFieldDelegate,
                                         UIActionSheetDelegate,
                                         UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray * devices;
@property (nonatomic, strong) DeviceGroup    * deviceGroup;
@property (nonatomic)         BOOL             isNewGroup;

@property (nonatomic, strong) IBOutlet UITableView * deviceTableView;
@property (nonatomic, strong) IBOutlet UITextField * groupNameField;
@property (nonatomic, strong) IBOutlet UIImageView * displayImage;
@property (nonatomic, strong) IBOutlet UIButton    * deleteButton;

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
    
    [self revertBackToDevicesView];
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
    
    [self revertBackToDevicesView];
}

- (void) revertBackToDevicesView
{
    self.displayImage.image = nil;
    self.deviceGroup = nil;
    self.selectedActionsForDevices = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) changeGroupImage : (id)sender
{
    //todo: show if camera is available
    if ( [UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary] == NO ) return;
    
    UIActionSheet * photoPickerActionSheet;
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES ) {

        photoPickerActionSheet =
            [[UIActionSheet alloc] initWithTitle : nil
                                        delegate : self
                               cancelButtonTitle : @"Cancel"
                          destructiveButtonTitle : nil
                               otherButtonTitles :
                                        @"Choose Photo",
                                        @"Take Photo",
                                        nil];
    } else {
        photoPickerActionSheet =
            [[UIActionSheet alloc] initWithTitle : nil
                                        delegate : self
                               cancelButtonTitle : @"Cancel"
                          destructiveButtonTitle : nil
                               otherButtonTitles :
                                        @"Choose Photo",
                                        nil];
    }
    
    photoPickerActionSheet.tag = LHPhotoPickerActionSheetTag;
    [photoPickerActionSheet showInView : [UIApplication sharedApplication].keyWindow];
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
    
    self.displayImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.displayImage.layer.borderWidth = 0.3;
    self.displayImage.layer.cornerRadius = 8;
    self.displayImage.layer.masksToBounds = YES;
    
    self.deviceTableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
}

- (void) initializeWithDevices : (NSMutableArray *) devices
               withDeviceGroup : (DeviceGroup *) deviceGroup
                    isNewGroup : (BOOL) isNewGroup
{
    self.isNewGroup = isNewGroup;
    self.devices = devices;
    self.deviceGroup = deviceGroup;
    self.selectedActionsForDevices = [[NSMutableDictionary alloc] init];
    
    for ( int i =0; i < devices.count; i++  ) {
        LHDevice * device = devices[i];
        LHAction * action = [device actionForActionId :
                             [self.deviceGroup.actions objectForKey : device.identifier]];
        
        //the device was not found before or, this is a new group
        if ( !action ) {
            if ( isNewGroup ) {
                action = [device actionForActionId : device.defaultActionId];
            }
            //not new group or device does not have default action. just ignore it.
            if ( !action ) {
                action = [device actionForActionId : LHIgnoreActionId];
            }
        }
        
        [self.selectedActionsForDevices setObject : action.identifier
                                           forKey : device.identifier];

    }
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    LHAction * action = [device actionForActionId :
                         [self.selectedActionsForDevices objectForKey : device.identifier]];
    
    [self updateCurrentActionForDevice : device
                            withAction : action
                        forDisplayCell : cell];

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
        return [aDevice actionCount];
    };

    pickerViewController.updateCellAtIndexPathCallback =
    ^ (UITableViewCell * cell, NSIndexPath * indexPath) {
        LHAction * action = [aDevice actionAtIndex : indexPath.row];
        cell.textLabel.text = action.friendlyName;
        
        if ([action.identifier isEqualToString :
             [self.selectedActionsForDevices objectForKey : aDevice.identifier]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    };
    
    pickerViewController.didSelectRowAtIndexPathCallback = ^ (NSIndexPath * indexPath) {
        LHAction * action = [aDevice actionAtIndex : indexPath.row];
        [self.selectedActionsForDevices setObject : action.identifier
                                           forKey : aDevice.identifier];
        
        [self updateCurrentActionForDevice : aDevice
                                withAction : action
                            forDisplayCell : deviceSelectionCell];
    };
    
    [self presentViewController : navigationController animated : YES completion : nil];
}

- (void) updateCurrentActionForDevice : (LHDevice *) aDevice
                           withAction : (LHAction *) anAction
                       forDisplayCell : (LHGroupDeviceTableViewCell *) aCell
{
    [aCell.actionPickerButton setTitle : anAction.friendlyName
                             forState : UIControlStateNormal];
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

- (void) actionSheet : (UIActionSheet *) actionSheet
clickedButtonAtIndex : (NSInteger) buttonIndex
{
    if ( actionSheet.tag == LHPhotoPickerActionSheetTag ) {
        
        if ( actionSheet.cancelButtonIndex == buttonIndex ) return;
            
        UIImagePickerController * pickerUi = [[UIImagePickerController alloc] init];
        pickerUi.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        pickerUi.allowsEditing = NO;
        pickerUi.delegate = self;
        
        if ( buttonIndex == 0 ) {         // select from library
            pickerUi.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if ( buttonIndex == 1 ) {  // take a photo
            pickerUi.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
        [self.navigationController presentViewController : pickerUi
                                                animated : YES
                                              completion : nil];
    }
    
}

#pragma mark - image picker controller

- (void) imagePickerControllerDidCancel : (UIImagePickerController *) picker
{
    [self.navigationController dismissViewControllerAnimated : YES completion : nil];
}

- (void) imagePickerController : (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo : (NSDictionary *) info
{
    
    NSString * mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage * originalImage = nil;
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
    }
    
    [self.navigationController dismissViewControllerAnimated : YES
                                                  completion : ^ {
                                                      if (originalImage != nil) {
                                                          self.displayImage.image =
                                                            [self scaleImage : originalImage toFillSize : CGSizeMake ( 90, 90 )];
                                                      }
                                                  }];
}

- (UIImage *) scaleImage : (UIImage *) image toFillSize : (CGSize) size
{
    CGFloat scale = MAX ( size.width / image.size.width,
                          size.height / image.size.height );
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake( (size.width - width) / 2.0f,
                                   (size.height - height) / 2.0f,
                                   width,
                                   height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
