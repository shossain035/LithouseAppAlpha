//
//  LHMainMenuViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 5/10/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHMainMenuViewController.h"

NSString * const LSMenuCellReuseIdentifier = @"Drawer Cell";

@interface LHMainMenuViewController ()
@property (nonatomic, strong) NSDictionary    * paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary    * paneViewControllerIdentifiers;

@property (nonatomic, strong) UIBarButtonItem * drawerBarButtonItem;
@end

@implementation LHMainMenuViewController

#pragma mark - NSObject

- (instancetype) initWithCoder : (NSCoder *) aDecoder
{
    self = [super initWithCoder : aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - UIViewController

- (instancetype) initWithNibName : (NSString *) nibNameOrNil
                          bundle : (NSBundle *) nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer * backgroundLayer = [self backgroundGradient];
    backgroundLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:backgroundLayer atIndex : 0];
}

//gradient background
- (CAGradientLayer *) backgroundGradient {

    UIColor * topColor = [UIColor colorWithRed : 0.022 green : 0.865 blue : 0.022 alpha : 1];
    UIColor * bottomColor = [UIColor colorWithRed : 0.022 green : 0.665 blue : 0.22 alpha : 1];
    
    NSArray * colors = [NSArray arrayWithObjects : (id)topColor.CGColor, bottomColor.CGColor, nil];
    NSNumber * stopOne = [NSNumber numberWithFloat : 0.0];
    NSNumber * stopTwo = [NSNumber numberWithFloat : 1.0];
    
    NSArray * locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer * headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

#pragma mark - MSMenuViewController

- (void)initialize
{
    self.paneViewControllerType = NSUIntegerMax;
    
    self.paneViewControllerTitles = @{
                                      @(LHPaneViewControllerTypeDevicesAndTriggers) : @"Devices",
                                      @(LHPaneViewControllerTypeContactUs)          : @"Contact Us",
                                      @(LHPaneViewControllerTypeAbout)              : @"About"
                                      };
    
    self.paneViewControllerIdentifiers = @{
                                           @(LHPaneViewControllerTypeDevicesAndTriggers) : @"DevicesAndTriggers",
                                           @(LHPaneViewControllerTypeContactUs)          : @"ContactUs",
                                           @(LHPaneViewControllerTypeAbout)              : @"About"
                                           };
    
    self.drawerBarButtonItem = [[UIBarButtonItem alloc] initWithImage : [UIImage imageNamed : @"Drawer"]
                                                                style : UIBarButtonItemStyleBordered
                                                               target : self
                                                               action : @selector(drawerBarButtonItemTapped:)];
    
}

- (void) drawerBarButtonItemTapped : (id) sender
{
    [self.dynamicsDrawerViewController setPaneState : MSDynamicsDrawerPaneStateOpen
                                        inDirection : MSDynamicsDrawerDirectionLeft
                                           animated : YES
                              allowUserInterruption : YES
                                         completion : nil];
}

- (void) transitionToViewController : (LHPaneViewControllerType) paneViewControllerType
{
    // Close pane if already displaying the pane view controller
    if ( paneViewControllerType == self.paneViewControllerType ) {
        [self.dynamicsDrawerViewController setPaneState : MSDynamicsDrawerPaneStateClosed
                                               animated : YES
                                  allowUserInterruption : YES
                                             completion : nil];
        return;
    }
    
    BOOL animateTransition = self.dynamicsDrawerViewController.paneViewController != nil;
    
    UINavigationController * paneViewController = [self.storyboard
                                                   instantiateViewControllerWithIdentifier
                                                   : self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
    
    UIViewController * topViewController = [paneViewController.childViewControllers objectAtIndex : 0];
    topViewController.navigationItem.leftBarButtonItem = self.drawerBarButtonItem;
    
    [self.dynamicsDrawerViewController setPaneViewController : paneViewController
                                                    animated : animateTransition
                                                  completion : nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

- (LHPaneViewControllerType) paneViewControllerTypeForIndexPath : (NSIndexPath *) indexPath
{
    //todo: limit checking
    return indexPath.row;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView : (UITableView *) tableView
{
    return 1;
}

- (NSInteger)tableView : (UITableView *) tableView numberOfRowsInSection : (NSInteger) section
{
    return [self.paneViewControllerTitles count];
}


- (UITableViewCell *) tableView : (UITableView *) tableView cellForRowAtIndexPath : (NSIndexPath *) indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier : LSMenuCellReuseIdentifier
                                                            forIndexPath : indexPath];
    
    cell.textLabel.text = self.paneViewControllerTitles[@([self paneViewControllerTypeForIndexPath : indexPath])];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView : (UITableView *) tableView didSelectRowAtIndexPath : (NSIndexPath *) indexPath
{
    LHPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath : indexPath];
    [self transitionToViewController : paneViewControllerType];
    
    // Prevent visual display bug with cell dividers
    [tableView deselectRowAtIndexPath : indexPath animated : YES];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableView reloadData];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
