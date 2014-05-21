//
//  LHDevicesViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHAppDelegate.h"
#import "LHDevicesViewController.h"
#import "LHGroupCRUDViewController.h"
#import "LHDevice.h"
#import "LHWeMoSwitch.h"
#import "LHHueBulb.h"
#import "LHDeviceGroup.h"
#import "LHDeviceCell.h"
#import "WeMoNetworkManager.h"
#import "WeMoConstant.h"
#import <HueSDK_iOS/HueSDK.h>


NSString * const LHDeviceCellReuseIdentifier    = @"DevicesAndTriggerCell";
NSString * const LHPushGroupCRUDSegueIdentifier = @"PushGroupCRUDSegue";
int const        LHSpinnerViewTag               = 1001;

@interface LHDevicesViewController ()

@property NSMutableArray                                     * devicesAndGroups;
@property NSMutableSet                                       * deviceIds;
@property (nonatomic, strong) PHBridgeSearching              * bridgeSearch;
@property (nonatomic, strong) PHBridgePushLinkViewController * pushLinkViewController;

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
    
    self.deviceIds = [[NSMutableSet alloc] init];
    self.devicesAndGroups = [[NSMutableArray alloc] init];
    NSMutableArray * devices = [[NSMutableArray alloc] init];
    NSMutableArray * deviceGroups = [[NSMutableArray alloc] init];
    
    [self.devicesAndGroups addObject : devices];
    [self.devicesAndGroups addObject : deviceGroups];
    
    /*
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
    */
    
    // Listen for notifications
    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    /***************************************************
     The SDK will send the following notifications in response to events
     *****************************************************/
    
    [notificationManager registerObject : self
                           withSelector : @selector ( localConnection )
                        forNotification : LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject : self
                           withSelector : @selector ( noLocalConnection )
                        forNotification : NO_LOCAL_CONNECTION_NOTIFICATION];
    /***************************************************
     If there is no authentication against the bridge this notification is sent
     *****************************************************/
    
    [notificationManager registerObject : self
                           withSelector : @selector ( notAuthenticated )
                        forNotification : NO_LOCAL_AUTHENTICATION_NOTIFICATION];
    
    [self enableLocalHeartbeat];

}

- (void) viewWillAppear : (BOOL) animated
{
    [self showSpinner];
}

- (void) viewDidAppear : (BOOL) animated
{
    [self refreshDeviceList];
}

- (void) showSpinner
{
    CGRect screenRectangle = [[UIScreen mainScreen] bounds];
    UIView * coverView = [[UIView alloc] initWithFrame : screenRectangle];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent : 0.3];
    
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle : UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.navigationController.view.center;
    [coverView addSubview : spinner];
    [spinner startAnimating];
    
    coverView.tag = LHSpinnerViewTag;
    [self.navigationController.view addSubview : coverView];
}

- (void) hideSpinner
{
    UIView * spinnerCoverView = [self.navigationController.view viewWithTag : LHSpinnerViewTag];
    [spinnerCoverView removeFromSuperview];
}

- (void) reloadDeviceList
{
    // hiding at the first one
    [self hideSpinner];
    [self.collectionView reloadData];
}

- (void) refreshDeviceList
{
    [[self.devicesAndGroups objectAtIndex : 0] removeAllObjects];
    [[self.devicesAndGroups objectAtIndex : 1] removeAllObjects];
    [self.deviceIds removeAllObjects];
    
    [self.collectionView reloadData];
    
    WeMoNetworkManager * networkManager = [WeMoNetworkManager sharedWeMoNetworkManager];
    NSString * routerSsid = [networkManager accessPoint];
    NSLog(@"ssid = %@",routerSsid);
    
    if ( [routerSsid isEqualToString : EMPTY_STRING]
            || ([routerSsid hasPrefix : WEMO_SSID] == YES)) {
        [self hideSpinner];
        //UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:ALERT_BUTTON_TITLE message:NETWORK_CHANGE_MESSAGE delegate:nil cancelButtonTitle:OK_BUTTON otherButtonTitles: nil] autorelease];
        //[alertView show];
    }else{
        @synchronized( self.devicesAndGroups ){
            [self updateHueLights];
            
            NSLog(@"refreshListFromSDK");
            WeMoDiscoveryManager * discoveryManager = [WeMoDiscoveryManager sharedWeMoDiscoveryManager];
            discoveryManager.deviceDiscoveryDelegate = self;
            [discoveryManager discoverDevices : WeMoUpnpInterface];
        }
    }

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
    
    cell.toggleCallbackBlock = ^{
        [(id <LHToogleHandler>) device toggle];
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
    
    LHDeviceCell * cell = (LHDeviceCell *) [collectionView cellForItemAtIndexPath : indexPath];
    
    CABasicAnimation * borderAnimation = [CABasicAnimation animationWithKeyPath : @"borderWidth"];
    [borderAnimation setFromValue : [NSNumber numberWithFloat : cell.layer.borderWidth]];
    [borderAnimation setToValue : [NSNumber numberWithFloat : 0.0f]];
    [borderAnimation setRepeatCount : 1.0];
    [borderAnimation setAutoreverses : NO];
    [borderAnimation setDuration : 0.3f];
    
    [cell.layer addAnimation : borderAnimation forKey : @"animateBorder"];
    
    cell.toggleCallbackBlock();
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

#pragma mark - WeMo Discovery Delegate
- (void) discoveryManager : (WeMoDiscoveryManager *) manager
           didFoundDevice : (WeMoControlDevice *) device
{
    NSLog(@"didFound Wemo Device ");
    
    @synchronized ( self.devicesAndGroups ) {
        //already discovered
        if ( [self.deviceIds containsObject : device.udn] ) return;
        [self.deviceIds addObject : device.udn];
            
        //Insight devices have 3 states (ON/OFF/IDLE. So called a separate UPnP method to handle IDLE state. Insight device type is 2 as mentioned in DeviceConfigData.plist file.)
        if (device.deviceType == 2)
        {
            //todo
            //[self getStatusForInsightDevice:device];
        }
        
        LHWeMoSwitch * weMoDevice = [[LHWeMoSwitch alloc] initWithWeMoControlDevice : device];
        
        NSMutableArray * devices = [self.devicesAndGroups objectAtIndex : 0];
        [devices addObject : weMoDevice];
        
        NSLog(@"discoverDevices device = %d:%@",device.deviceType, device.friendlyName);
        [self performSelectorOnMainThread : @selector(reloadDeviceList)
                               withObject : nil
                            waitUntilDone : NO];
    }
}

-(void)discoveryManager : (WeMoDiscoveryManager *) manager
    removeDeviceWithUdn : (NSString*) udn {
    //todo:
    /*NSLog(@"removeDeviceNotificationWithUserInfo");
    @synchronized(devicesArray){
        for (WeMoControlDevice* aDevice in devicesArray) {
            if ([aDevice.udn isEqualToString:udn]){
                if (self.wemoDeviceDetail) {
                    [self.wemoDeviceDetail deviceRemoved];
                }
                [devicesArray removeObject:aDevice];
                [deviceListTableView reloadData];
                return;
            }
        }
    }*/
}

-(void) discoveryManagerRemovedAllDevices : (WeMoDiscoveryManager *) manager
{
    /*
    NSLog(@"removeAllDevicesNotificationWithUserInfo");
    
    @synchronized(devicesArray){
        [devicesArray removeAllObjects];
        [deviceListTableView reloadData];
    }*/
    //todo
}

#pragma mark - HueSDK

/**
 Notification receiver for successful local connection
 */
- (void)localConnection {
    // Check current connection state
    NSLog ( @"localConnection" );
    
    //todo: check if at least one light is reachable
    [self updateHueLights];
}

- (void) updateHueLights {
    PHBridgeResourcesCache * cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    for (PHLight * light in cache.lights.allValues) {
        if ( [light.lightState.reachable boolValue]
             && ![self.deviceIds containsObject : light.identifier] ) {
            
            NSLog ( @"light: %@", light.name );

            [self.deviceIds addObject : light.identifier];
            
            LHHueBulb * hueBulb = [[LHHueBulb alloc] initWithPHLight : light];
            
            NSMutableArray * devices = [self.devicesAndGroups objectAtIndex : 0];
            [devices addObject : hueBulb];
            
            [self performSelectorOnMainThread : @selector(reloadDeviceList)
                                   withObject : nil
                                waitUntilDone : NO];
        }
    }

}

/**
 Notification receiver for failed local connection
 */
- (void)noLocalConnection {
    // Check current connection state
    NSLog ( @"noLocalConnection" );
}

/**
 Notification receiver for failed local authentication
 */
- (void)notAuthenticated {
    NSLog ( @"notAuthenticated" );
    
    self.pushLinkViewController = [[PHBridgePushLinkViewController alloc]
                                   initWithHueSDK  : [LHAppDelegate getHueSDK]
                                   bundle : [NSBundle mainBundle]
                                   delegate : self];
    
    [self.navigationController presentViewController : self.pushLinkViewController
                                            animated : YES
                                          completion : ^{
     
                                              // Start pushlinking when the interface is shown
                                              [self.pushLinkViewController startPushLinking];
                                          }];


}


#pragma mark - PHBridgePushLinkViewController
/**
 Delegate method for PHBridgePushLinkViewController which is invoked if the pushlinking was successfull
 */
- (void)pushlinkSuccess {
  /*
    // Remove pushlink view controller
    [self.navigationController dismissViewControllerAnimated : YES completion : nil];
    self.pushLinkViewController = nil;
    
    // Start local heartbeat
    [self performSelector : @selector(enableLocalHeartbeat)
               withObject : nil
               afterDelay : 1];
*/
}

/**
 Delegate method for PHBridgePushLinkViewController which is invoked if the pushlinking was not successfull
 */

- (void)pushlinkFailed:(PHError *)error {

    // Remove pushlink view controller
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    self.pushLinkViewController = nil;
    
    // Check which error occured
    if (error.code == PUSHLINK_NO_CONNECTION) {
        // No local connection to bridge
        [self noLocalConnection];
        
        // Start local heartbeat (to see when connection comes back)
        [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
    }
    else {
        // Bridge button not pressed in time
        [[[UIAlertView alloc] initWithTitle : NSLocalizedString(@"Authentication failed", @"Authentication failed alert title")
                                    message : NSLocalizedString(@"Make sure you press the button within 30 seconds", @"Authentication failed alert message")
                                   delegate : self
                          cancelButtonTitle : nil
                          otherButtonTitles : NSLocalizedString(@"Retry", @"Authentication failed alert retry button"), NSLocalizedString(@"Cancel", @"Authentication failed cancel button"), nil] show];
    }
 
}

#pragma mark - Heartbeat control

/**
 Starts the local heartbeat with a 10 second interval
 */
- (void)enableLocalHeartbeat {
    /***************************************************
     The heartbeat processing collects data from the bridge
     so now try to see if we have a bridge already connected
     *****************************************************/
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    if ( cache != nil && cache.bridgeConfiguration != nil
        && cache.bridgeConfiguration.ipaddress != nil ) {
        // Enable heartbeat with interval of 15 seconds
        [[LHAppDelegate getHueSDK] enableLocalConnectionUsingInterval:15];
    } else {
        // Automaticly start searching for bridges
        [self searchForBridgeLocal];
    }
}

/**
 Stops the local heartbeat
 */
- (void)disableLocalHeartbeat {
    [[LHAppDelegate getHueSDK] disableLocalConnection];
}

#pragma mark - Bridge searching and selection

/**
 Search for bridges using UPnP and portal discovery, shows results to user or gives error when none found.
 */
- (void)searchForBridgeLocal {
    // Stop heartbeats
    [self disableLocalHeartbeat];
    
    /***************************************************
     A bridge search is started using UPnP to find local bridges
     *****************************************************/
    
    // Start search
    self.bridgeSearch = [[PHBridgeSearching alloc] initWithUpnpSearch : YES
                                                      andPortalSearch : NO
                                                    andIpAdressSearch : NO];
    
    [self.bridgeSearch startSearchWithCompletionHandler : ^( NSDictionary *bridgesFound ) {
        
        /***************************************************
         The search is complete, check whether we found a bridge
         *****************************************************/
        
        // Check for results
        if (bridgesFound.count > 0) {
            NSLog ( @"bridges: %@", bridgesFound );
            //warning: selecting first bridge by default.
            //todo: create a bridge selection view.
            NSString * macAddress = [bridgesFound.allKeys objectAtIndex : 0];
            [[LHAppDelegate getHueSDK] setBridgeToUseWithIpAddress : [bridgesFound objectForKey : macAddress]
                                                        macAddress : macAddress];
        }
        else {
            NSLog ( @"No HUE bridge found" );
            //            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle : @"No bridge found"
            //                                                                 message : @"Could not find a Hue bridge. Please make sure that the bridge is powered up and connected to router."
            //                                                       cancelButtonTitle : @"Cancel"
            //                                                       otherButtonTitles : NSLocalizedString(@"Retry", @"No bridge found alert retry button"),NSLocalizedString(@"Cancel", @"No bridge found alert cancel button"), nil];
            //            [alertView show];
        }
    }];
}



@end
