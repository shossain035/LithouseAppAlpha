//
//  LHDetailCollectionViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 6/24/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDetailCollectionViewController.h"
#import "DeviceProtocols.h"
#import "NKOColorPickerView.h"

@interface LHDetailCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NKOColorPickerView * pickerView;

@end

@implementation LHDetailCollectionViewController

static int const LHScheduleCellHeight = 150;

- (IBAction) back : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
    //important: otherwise touches inside control view will cause scrolling.
    self.collectionView.canCancelContentTouches = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if ( self.device != nil ) return 1;
        else return 0;
    }else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if ( indexPath.section == 0 ) {
        if ( [self.device conformsToProtocol:@protocol(LHLightColorChanging)] ) {
            cell = [self collectionView:collectionView colorPickerCellForItemAtIndexPath:indexPath];
        } else {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HiddenCell" forIndexPath:indexPath];
        }
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    }
    
    return cell;
}


- (UICollectionReusableView *) collectionView : (UICollectionView *) collectionView
            viewForSupplementaryElementOfKind : (NSString *) kind
                                  atIndexPath : (NSIndexPath *) indexPath
{
    UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader
                                                                               withReuseIdentifier : @"DetailCollectionHeader"
                                                                                      forIndexPath : indexPath];
    // no schedules available. hide the header bar
//    if ([[self.devicesAndGroups objectAtIndex : 1] count] == 0) headerView.hidden = YES;
//    else headerView.hidden = NO;
    return headerView;
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return CGSizeMake ( self.collectionView.bounds.size.width, [self heightOfDetailControllerForDevice] );
    } else {
        return CGSizeMake ( self.collectionView.bounds.size.width, LHScheduleCellHeight );
    }
}

- (CGSize) collectionView : (UICollectionView *) collectionView
                   layout : (UICollectionViewLayout*) collectionViewLayout
referenceSizeForHeaderInSection : (NSInteger) section
{
    if ( section == 0 ) {
        return CGSizeMake (0, 0);
    }else {
        return CGSizeMake ( self.collectionView.bounds.size.width, 25 );
    }
}

- (int) heightOfDetailControllerForDevice
{
    //sending a positive size. otherwise collection view acts strange.
    if ( self.device == nil ) return 1;
    
    if ([self.device conformsToProtocol:@protocol(LHLightColorChanging)]) {
        return 264;
    }
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
       colorPickerCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ColorPickerCell"
                                                                            forIndexPath:indexPath];
    if ( self.pickerView == nil ) {
        self.pickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 0,
                                    self.collectionView.bounds.size.width, [self heightOfDetailControllerForDevice])];
        
        [self.pickerView setTintColor:[UIColor lightGrayColor]];
    }
    
    id<LHLightColorChanging> colorChangingDevice = (id<LHLightColorChanging>) self.device;
    
    [self.pickerView setColor:[colorChangingDevice getCurrentColor]];
    [self.pickerView setDidChangeColorBlock:^(UIColor *color) {
        [colorChangingDevice updateColor:color];
    }];
    
    [self.pickerView removeFromSuperview];
    [cell.contentView addSubview:self.pickerView];
    
    return cell;
}

@end
