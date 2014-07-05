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
#import "LHThermostatCell.h"
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

@implementation LHDetailCollectionViewController {
    dispatch_source_t _thermostatRefreshTimer;
}

static int const LHScheduleCellWidth     = 300;
static int const LHScheduleCellHeight    = 66;
static int const LHColorPickerCellHeight = 264;
static int const LHThermostatCellHeight  = 264;

- (IBAction) back : (id) sender
{
    //invalidate all timers.
    //todo: check memory management issues.
    _thermostatRefreshTimer = nil;
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
    
    [[NSNotificationCenter defaultCenter]
         addObserverForName : LHScheduleCollectionChangedNotification
         object             : nil
         queue              : [NSOperationQueue mainQueue]
         usingBlock         : ^ (NSNotification * notification)
         {
             self.schedules = [((id<LHScheduleing>)self.device) getSchedules];
             [self.collectionView reloadData];
         }
     ];
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
        } else if ( [self.device conformsToProtocol:@protocol(LHThermostatSetting)] ) {
            cell = [self collectionView:collectionView thermostatCellForItemAtIndexPath:indexPath];
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
        [scheduleCell activate:schedule.enabled];
        
        scheduleCell.toggleCallbackBlock = ^{
            //toogle current state
            [schedule enable:!schedule.enabled];
        };

        scheduleCell.infoButtonCallback = ^{
            self.currentSchedule = schedule;
        
            [self performSegueWithIdentifier : LHSegueForEditingSchedule
                                      sender : self];
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
    
    LHScheduleCell * cell = (LHScheduleCell *) [collectionView cellForItemAtIndexPath : indexPath];
    
    [cell toggle];
}

#pragma mark <UICollectionViewDelegateFlowLayout>
- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {
        return CGSizeMake ( self.collectionView.bounds.size.width, [self heightOfDetailControllerForDevice] );
    } else {
        return CGSizeMake ( LHScheduleCellWidth, LHScheduleCellHeight );
    }
}

- (CGSize) collectionView : (UICollectionView *) collectionView
                   layout : (UICollectionViewLayout*) collectionViewLayout
referenceSizeForHeaderInSection : (NSInteger) section
{
    if ( section == 0 ) {
        return CGSizeMake (0, 0);
    }else {
        return CGSizeMake ( self.collectionView.bounds.size.width, 33 );
    }
}

- (int) heightOfDetailControllerForDevice
{
    //sending a positive size. otherwise collection view acts strange.
    if ( self.device == nil ) return 1;
    
    if ([self.device conformsToProtocol:@protocol(LHLightColorChanging)]) {
        return LHColorPickerCellHeight;
    }
    
    if ([self.device conformsToProtocol:@protocol(LHThermostatSetting)]) {
        return LHThermostatCellHeight;
    }

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
        thermostatCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHThermostatCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThermostatCell"
                                                                            forIndexPath:indexPath];
    
    [cell configureWithThermostat:(id<LHThermostatSetting>)self.device];
    
    _thermostatRefreshTimer = [self createDispatchTimerWithInterval:5ull * NSEC_PER_SEC
                                                         withLeeway:1ull * NSEC_PER_SEC
                                                          withQueue:dispatch_get_main_queue()
                                                              withBlock:^{
                                                                  NSLog(@"thermostat refresh.");
                                                                  [cell refresh];
                                                              }];
    
    return cell;
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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(dispatch_source_t) createDispatchTimerWithInterval:(uint64_t) interval
                                          withLeeway:(uint64_t) leeway
                                           withQueue:(dispatch_queue_t) queue
                                           withBlock:(dispatch_block_t) block
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}


@end
