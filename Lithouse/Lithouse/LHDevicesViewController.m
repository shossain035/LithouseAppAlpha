//
//  LHDevicesViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDevicesViewController.h"
#import "LHDevice.h"
#import "LHTrigger.h"
#import "LHDeviceCell.h"

NSString * const LSDeviceCellReuseIdentifier = @"DevicesAndTriggerCell";

@interface LHDevicesViewController ()

@property NSMutableArray * devices;

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
    
    self.devices = [[NSMutableArray alloc] init];
    
    LHDevice * device1 = [[LHDevice alloc] init];
    device1.deviceName = @"device1";
    device1.deviceImage = [UIImage imageNamed : @"unknown"];
    [self.devices addObject : device1];
    
    LHDevice * device2 = [[LHDevice alloc] init];
    device2.deviceName = @"device2";
    device2.deviceImage = [UIImage imageNamed : @"unknown"];
    [self.devices addObject : device2];
    
    LHDevice * device3 = [[LHDevice alloc] init];
    device3.deviceName = @"device3";
    device3.deviceImage = [UIImage imageNamed : @"unknown"];
    [self.devices addObject : device3];
    
    LHDevice * device4 = [[LHDevice alloc] init];
    device4.deviceName = @"device4";
    device4.deviceImage = [UIImage imageNamed : @"unknown"];
    [self.devices addObject : device4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets) collectionView : (UICollectionView *) collectionView
                         layout : (UICollectionViewLayout *) collectionViewLayout
         insetForSectionAtIndex : (NSInteger) section
{
    UIEdgeInsets insets = { .left = 5, .right = 5, .top = 5 };
    return insets;
}

#pragma mark - Collection view data source

- (NSInteger) collectionView : (UICollectionView *) view
      numberOfItemsInSection : (NSInteger) section;
{
    return [self.devices count];
}


- (UICollectionViewCell *) collectionView : (UICollectionView *) cv
                   cellForItemAtIndexPath : (NSIndexPath *) indexPath {
    
    LHDeviceCell * cell = [cv dequeueReusableCellWithReuseIdentifier : LSDeviceCellReuseIdentifier
                                                        forIndexPath : indexPath];
    
    LHDevice * device = [self.devices objectAtIndex : indexPath.row];
    
    cell.nameLabel.text = device.deviceName;
    cell.image.image = device.deviceImage;
    
    cell.layer.borderWidth = 0.5f;
    cell.layer.borderColor = [[UIColor greenColor] CGColor];

    return cell;
}

#pragma mark - Collection view delegate
- (void) collectionView : (UICollectionView *) collectionView didSelectItemAtIndexPath : (NSIndexPath *) indexPath
{
    NSLog ( @"item selected at %@", indexPath );
    
    /*
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath : indexPath];
    [UIView animateWithDuration : 1.0
                          delay : 0
                        options : (UIViewAnimationOptionAllowUserInteraction)
                     animations : ^{
                         cell.layer.borderColor = [[UIColor blueColor] CGColor];
                         cell.layer.borderWidth = 1;
                     }
                     completion : ^(BOOL finished){
                         cell.layer.borderColor = [[UIColor greenColor] CGColor];
                         cell.layer.borderWidth = 0.5f;
                     }
     ];
     */
}


@end
