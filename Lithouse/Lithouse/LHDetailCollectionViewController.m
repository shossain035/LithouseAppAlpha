//
//  LHDetailCollectionViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 6/24/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDetailCollectionViewController.h"
#import "LHScheduleViewController.h"
#import "LHScheduleCell.h"
#import "DeviceProtocols.h"
#import "NKOColorPickerView.h"
#import "LHAction.h"
#import "LHSchedule.h"

static NSString * const LHSegueForCreatingSchedule = @"SegueForCreatingSchedule";
static NSString * const LHSegueForEditingSchedule  = @"SegueForEditingSchedule";

@interface LHDetailCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NKOColorPickerView             * pickerView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem       * addScheduleBarButton;
@property (nonatomic, strong) NSArray                        * schedules;
@property (nonatomic, weak)   id<LHSchedule>                   currentSchedule;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( self.isSchedulable ) {
        self.navigationItem.rightBarButtonItem = self.addScheduleBarButton;
        self.schedules = [((id<LHScheduleing>)self.device) getSchedules];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) isSchedulable
{
    return (self.device && [self.device conformsToProtocol:@protocol(LHScheduleing)]);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ( self.isSchedulable ? 2 : 1 );
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ( section == 0 ) {
        if ( self.device != nil ) return 1;
        else return 0;
    }else {
        return self.schedules.count;
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
        LHScheduleCell * scheduleCell = (LHScheduleCell *) cell;
        id<LHSchedule> schedule = self.schedules[indexPath.row];
        scheduleCell.dateLabel.text = [NSDateFormatter localizedStringFromDate:schedule.fireDate
                                                                     dateStyle:NSDateFormatterShortStyle
                                                                     timeStyle:NSDateFormatterShortStyle];
        scheduleCell.actionLabel.text = schedule.action.friendlyName;
        //todo: recurrance
        scheduleCell.enableSwitch.on = schedule.enabled;
        scheduleCell.enableValueChangedCallback = ^(BOOL isEnabled) {
            [schedule enable:isEnabled];
        };
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
    return headerView;
}

#pragma mark - <UICollectionViewDelegate>
- (void) collectionView : (UICollectionView *) collectionView didSelectItemAtIndexPath : (NSIndexPath *) indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    
    self.currentSchedule = self.schedules[indexPath.row];
    [self performSegueWithIdentifier : LHSegueForEditingSchedule
                              sender : self];
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

-(void) prepareForSegue : (UIStoryboardSegue *) segue sender : (id) sender
{
    if ( [[segue identifier] isEqualToString : LHSegueForCreatingSchedule] ||
        [[segue identifier] isEqualToString : LHSegueForEditingSchedule] ) {
        id <LHScheduleing> schedulingDevice = (id <LHScheduleing>) self.device;
        LHScheduleViewController * targetViewController =
            (LHScheduleViewController *) segue.destinationViewController;
        
        targetViewController.device = (LHDevice *) self.device;
        
        if ( [[segue identifier] isEqualToString : LHSegueForCreatingSchedule] ) {
            targetViewController.schedule = [schedulingDevice createSchedule];
            targetViewController.isNewSchedule = YES;
        } else if ( [[segue identifier] isEqualToString : LHSegueForEditingSchedule] ) {
            targetViewController.schedule = self.currentSchedule;
            targetViewController.isNewSchedule = NO;
        }
    }
}

@end
