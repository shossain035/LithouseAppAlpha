//
//  LHDevicesViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevicesViewController.h"
#import "LHGroupCRUDViewController.h"
#import "LHDevice.h"
#import "LHWeMoSwitch.h"
#import "LHDeviceGroup.h"
#import "LHDeviceCell.h"


NSString * const LHDeviceCellReuseIdentifier    = @"DevicesAndTriggerCell";
NSString * const LHPushGroupCRUDSegueIdentifier = @"PushGroupCRUDSegue";

@interface LHDevicesViewController ()

@property NSMutableArray * devicesAndGroups;

@end

@implementation LHDevicesViewController

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
    
    self.devicesAndGroups = [[NSMutableArray alloc] init];
    NSMutableArray * devices = [[NSMutableArray alloc] init];
    NSMutableArray * deviceGroups = [[NSMutableArray alloc] init];
    [self.devicesAndGroups addObject : devices];
    [self.devicesAndGroups addObject : deviceGroups];
    
    LHDevice * device1 = [[LHDevice alloc] init];
    device1.friendlyName = @"device1";
    device1.displayImage = [UIImage imageNamed : @"unknown"];
    [devices addObject : device1];
    
    LHDevice * device2 = [[LHDevice alloc] init];
    device2.friendlyName = @"device2";
    device2.displayImage = [UIImage imageNamed : @"unknown"];
    [devices addObject : device2];
    
    LHDevice * device3 = [[LHDevice alloc] init];
    device3.friendlyName = @"device3";
    device3.displayImage = [UIImage imageNamed : @"unknown"];
    [devices addObject : device3];
    
    LHDevice * device4 = [[LHWeMoSwitch alloc] init];
    device4.friendlyName = @"WeMo";
    device4.displayImage = [UIImage imageNamed : @"unknown"];
    [devices addObject : device4];
    
    LHDeviceGroup * deviceGroup1 = [[LHDeviceGroup alloc] init];
    deviceGroup1.friendlyName = @"group1";
    deviceGroup1.displayImage = [UIImage imageNamed : @"unknown"];
    [deviceGroups addObject : deviceGroup1];
    
    LHDeviceGroup * deviceGroup2 = [[LHDeviceGroup alloc] init];
    deviceGroup2.friendlyName = @"group2";
    deviceGroup2.displayImage = [UIImage imageNamed : @"unknown"];
    [deviceGroups addObject : deviceGroup2];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view layout delegate

- (UIEdgeInsets) collectionView : (UICollectionView *) collectionView
                         layout : (UICollectionViewLayout *) collectionViewLayout
         insetForSectionAtIndex : (NSInteger) section
{
    //show margins
    UIEdgeInsets insets = { .left = 10, .right = 10, .top = 10, .bottom = 10 };
    return insets;
}

- (CGSize) collectionView : (UICollectionView *) collectionView
                   layout : (UICollectionViewLayout*) collectionViewLayout
referenceSizeForHeaderInSection : (NSInteger) section
{
    if ( section == 0 ) {
        return CGSizeMake ( 0, 0 );
    }else {
        return CGSizeMake ( self.collectionView.bounds.size.width, 25 );
    }
}

#pragma mark - Collection view data source

- (NSInteger) numberOfSectionsInCollectionView : (UICollectionView *) collectionView
{
    return 2;
}

- (NSInteger) collectionView : (UICollectionView *) view
      numberOfItemsInSection : (NSInteger) section;
{
    return [[self.devicesAndGroups objectAtIndex : section] count];
}

- (UICollectionViewCell *) collectionView : (UICollectionView *) cv
                   cellForItemAtIndexPath : (NSIndexPath *) indexPath
{
    
    LHDeviceCell * cell = [cv dequeueReusableCellWithReuseIdentifier : LHDeviceCellReuseIdentifier
                                                        forIndexPath : indexPath];
    
    LHDevice * device = [[self.devicesAndGroups objectAtIndex : indexPath.section]
                         objectAtIndex : indexPath.row];
    
    cell.nameLabel.text = device.friendlyName;
    cell.image.image = device.displayImage;
    
    cell.infoButtonCallback = ^{
        NSLog ( @"device info %@", device.friendlyName );
    };
    
    return cell;
}

- (UICollectionReusableView *) collectionView : (UICollectionView *) collectionView
            viewForSupplementaryElementOfKind : (NSString *) kind
                                  atIndexPath : (NSIndexPath *) indexPath
{
    UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader
                                                                               withReuseIdentifier : @"DeviceCollectionHeader"
                                                                                      forIndexPath : indexPath];
    return headerView;
}

#pragma mark - Collection view delegate
- (void) collectionView : (UICollectionView *) collectionView didSelectItemAtIndexPath : (NSIndexPath *) indexPath
{
    NSLog ( @"item selected at %@", indexPath );
    
   
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath : indexPath];
    
    CABasicAnimation * borderAnimation = [CABasicAnimation animationWithKeyPath : @"borderWidth"];
    [borderAnimation setFromValue : [NSNumber numberWithFloat : cell.layer.borderWidth]];
    [borderAnimation setToValue : [NSNumber numberWithFloat : 0.0f]];
    [borderAnimation setRepeatCount : 1.0];
    [borderAnimation setAutoreverses : NO];
    [borderAnimation setDuration : 0.3f];
    
    [cell.layer addAnimation : borderAnimation forKey : @"animateBorder"];
}

#pragma mark - Navigation

-(void) prepareForSegue : (UIStoryboardSegue *) segue sender : (id) sender
{
    if ( [[segue identifier] isEqualToString : LHPushGroupCRUDSegueIdentifier] ) {
        LHGroupCRUDViewController * targetViewController =
            (LHGroupCRUDViewController *) segue.destinationViewController;
        targetViewController.devices = [self.devicesAndGroups objectAtIndex : 0];
    }
    
}



@end
