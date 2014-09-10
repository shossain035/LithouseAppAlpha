//
//  LHMainMenuViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 5/10/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHMainMenuViewController.h"
#import "LHDevicesViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

#define ITUNES_APP_URL_IOS7 @"http://itunes.apple.com/app/id866665066"

NSString * const LSMenuCellReuseIdentifier = @"Drawer Cell";

@interface LHMainMenuViewController () <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSDictionary             * paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary             * paneViewControllerIdentifiers;

@property (nonatomic, strong) UIBarButtonItem          * drawerBarButtonItem;
@property (nonatomic, strong) IBOutlet UITableView     * tableView;

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
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
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
                                      @(LHPaneViewControllerTypeDevicesAndTriggers) : @"Search for Devices",
                                      @(LHPaneViewControllerTypeSupportedDevices)   : @"Devices We Support",
                                      @(LHPaneViewControllerTypeContactUs)          : @"Contact Us",
                                      @(LHPaneViewControllerTypeTweet)              : @"Tweet!"
                                      };
    
    self.paneViewControllerIdentifiers = @{
                                           @(LHPaneViewControllerTypeDevicesAndTriggers) : @"DevicesAndTriggers",
                                           @(LHPaneViewControllerTypeSupportedDevices)   : @"DevicesAndTriggers",
                                           @(LHPaneViewControllerTypeContactUs)          : @"DevicesAndTriggers",
                                           @(LHPaneViewControllerTypeTweet)              : @"DevicesAndTriggers"
                                           };
    
    self.drawerBarButtonItem = [[UIBarButtonItem alloc] initWithImage : [UIImage imageNamed : @"Drawer"]
                                                                style : UIBarButtonItemStylePlain
                                                               target : self
                                                               action : @selector(drawerBarButtonItemTapped:)];
    self.drawerBarButtonItem.tintColor = [UIColor whiteColor];
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
    //hnadle contact us
    if ( LHPaneViewControllerTypeContactUs == paneViewControllerType ) {
        [self sendEmailWithContent : [NSString stringWithFormat : @"</br></br></br>Lithouse v%@",
                                      [[[NSBundle mainBundle] infoDictionary] objectForKey : @"CFBundleShortVersionString"]]
                       withSubject : @"Feedback from iOS app"
                       toRecipents : [NSArray arrayWithObject : @"hello@litehouse.io"]];
        return;
    } else if ( LHPaneViewControllerTypeTweet == paneViewControllerType ) {
        [self twittTapped];
        return;
    } else if ( LHPaneViewControllerTypeDevicesAndTriggers == paneViewControllerType ) {
        [[NSNotificationCenter defaultCenter] postNotificationName : LHSearchForDevicesNotification
                                                            object : nil];
    } else if ( LHPaneViewControllerTypeSupportedDevices == paneViewControllerType ) {
        [[NSNotificationCenter defaultCenter] postNotificationName : LHSupportedDevicesNotification
                                                            object : nil];
    }
    
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

- (void) sendEmailWithContent : (NSString *) content
                  withSubject : subject
                  toRecipents : (NSArray *) recipients {
    
    MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init];
    [emailComposer setSubject : subject];
    [emailComposer setMessageBody : content isHTML : YES];
    [emailComposer setToRecipients : recipients];
    emailComposer.mailComposeDelegate = self;
    
    [self presentViewController : emailComposer animated : YES completion : NULL];
    
}

#pragma mark - Mail Compose ViewController Delegate
- (void) mailComposeController : (MFMailComposeViewController *) controller
           didFinishWithResult : (MFMailComposeResult) result
                         error : (NSError *) error {
    [self dismissViewControllerAnimated : YES completion : NULL];
}


- (void) twittTapped {
    
    if ( [SLComposeViewController isAvailableForServiceType : SLServiceTypeTwitter] ) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType : SLServiceTypeTwitter];
        [tweetSheet setInitialText : [NSString stringWithFormat : @"%@ by @litehouseio is the easiest way to connect #IoT",
                                      ITUNES_APP_URL_IOS7]];
        
        [self presentViewController : tweetSheet animated : YES completion : nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle : @"Sorry"
                                  message : @"Please make sure that you have a Twitter account setup."
                                  delegate : self
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil];
        
        [alertView show];
    }
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
