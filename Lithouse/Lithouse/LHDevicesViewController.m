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
#import "LHAlertView.h"
#import "WeMoNetworkManager.h"
#import "WeMoConstant.h"
#import <HueSDK_iOS/HueSDK.h>

#define INITIAL_HUE_HEARTBEAT_DELAY                  1
#define REGULAR_HUE_HEARTBEAT_DELAY                  10

NSString * const LHDeviceCellReuseIdentifier         = @"DevicesAndTriggerCell";
NSString * const LHPushGroupForCreateSegueIdentifier = @"PushGroupForCreateSegue";
NSString * const LHPushGroupForEditSegueIdentifier   = @"PushGroupForEditSegue";
NSString * const LHSearchForDevicesNotification      = @"LHSearchForDevicesNotification";

@interface LHDevicesViewController () <UIAlertViewDelegate>

@property NSMutableArray                                     * devicesAndGroups;
@property NSMutableDictionary                                * deviceDictionary;
@property (nonatomic, strong) PHBridgeSearching              * bridgeSearch;
@property (nonatomic, strong) PHBridgePushLinkViewController * pushLinkViewController;
@property (nonatomic, strong) NSString                       * isHueHeartbeatEnabled;

@property (nonatomic, weak)   LHDevice                       * selectedDevice;
@property (nonatomic, strong) LHAlertView                    * wifiDisconnectedAlert;
@property (nonatomic, strong) LHAlertView                    * hueHubNotAuthenticatedAlert;
@property (nonatomic, strong) LHAlertView                    * noDeviceAvailableAlert;
@property (nonatomic, strong) NSArray                        * alertArray;

@property (nonatomic, strong) UIView                         * spinnerView;
@property (nonatomic, strong) NSString                       * currentNetworkSSId;

@property (nonatomic, strong) IBOutlet UIBarButtonItem       * addGroupBarButton;
@property int                                                  hueHeartbeatDelay;

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
    
    self.isHueHeartbeatEnabled = @"NO";
    self.deviceDictionary = [[NSMutableDictionary alloc] init];
    self.devicesAndGroups = [[NSMutableArray alloc] init];
    NSMutableArray * devices = [[NSMutableArray alloc] init];
    NSMutableArray * deviceGroups = [[NSMutableArray alloc] init];
    
    [self.devicesAndGroups addObject : devices];
    [self.devicesAndGroups addObject : deviceGroups];
    
    [self listenForHueNotifications : YES];
    
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(didNetworkChanged:)
                                                 name : wemoNetworkChangeNotification
                                               object : nil];
    [[NSNotificationCenter defaultCenter] addObserver : self
                                             selector : @selector(searchForDevices:)
                                                 name : LHSearchForDevicesNotification
                                               object : nil];
    
    [self createHelperViews];
    
    [NSTimer scheduledTimerWithTimeInterval : 15.0
                                     target : self
                                   selector : @selector(checkAppStatus)
                                   userInfo : nil
                                    repeats : YES];
}

- (void) createHelperViews
{
    //wifi missing alert
    self.wifiDisconnectedAlert =
        [[LHAlertView alloc] initWithTitle : @"No WiFi Connection"
                                   message : @"Please connect to your home WiFi network."
                                  delegate : self
                         cancelButtonTitle : @"Retry"
                         otherButtonTitles : nil];
    //hub authentication alert
    self.hueHubNotAuthenticatedAlert =
        [[LHAlertView alloc] initWithTitle : @"Authentication Failed"
                                   message : @"Please press the button on the hub within 30 seconds."
                                  delegate : self
                         cancelButtonTitle : @"Cancel"
                         otherButtonTitles : @"Retry", nil];
    
    //no device found alert
    self.noDeviceAvailableAlert =
        [[LHAlertView alloc] initWithTitle : @"No Devices Found"
                                   message : @"Please power up your WeMo or Hue and connect them to network."
                                  delegate : self
                         cancelButtonTitle : @"Retry"
                         otherButtonTitles : nil];
    
    self.alertArray = @[self.wifiDisconnectedAlert,
                        self.hueHubNotAuthenticatedAlert,
                        self.noDeviceAvailableAlert];
    
    //spinner view
    CGRect screenRectangle = [[UIScreen mainScreen] bounds];
    self.spinnerView = [[UIView alloc] initWithFrame : screenRectangle];
    self.spinnerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent : 0.3];
    
    UIActivityIndicatorView * spinner = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle : UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = self.navigationController.view.center;
    [self.spinnerView addSubview : spinner];
    [spinner startAnimating];

}

- (void) viewWillAppear : (BOOL) animated
{
    [self refreshDeviceList];
}


- (void) showSpinner
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.spinnerView removeFromSuperview];
        
        if ( ![self isAlertsVisible] ) {
            [self.navigationController.view addSubview : self.spinnerView];
        }
    });
}

- (BOOL) isAlertsVisible {
    for ( LHAlertView * alert in self.alertArray ) {
        if ( alert.isAlertViewVisible ) return YES;
    }
    
    return NO;
}

- (void) hideSpinner
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.spinnerView performSelector : @selector(removeFromSuperview)
                               withObject : nil
                               afterDelay : 1.0];
    });
}

- (void) reloadDeviceList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // hiding at the first one
        [self hideSpinner];
        
        //todo: consolidate
        if ( self.deviceDictionary.count > 0  ) {
            self.addGroupBarButton.enabled = true;
            [self.noDeviceAvailableAlert dismissWithClickedButtonIndex : self.noDeviceAvailableAlert.cancelButtonIndex
                                                              animated : YES];
        } else {
            self.addGroupBarButton.enabled = false;
        }
        
        
        [self.collectionView reloadData];
    });
}

- (void) refreshDeviceList
{
    [self refreshDeviceList : NO];
}

- (void) refreshDeviceList : (BOOL) doInBackground
{
    if ( !doInBackground ) [self showSpinner];
    
    if ( ![self isWiFiConnected] ) return;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self updateHueLights];
    });
            
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        WeMoDiscoveryManager * discoveryManager = [WeMoDiscoveryManager sharedWeMoDiscoveryManager];
        discoveryManager.deviceDiscoveryDelegate = self;
        [discoveryManager discoverDevices : WeMoUpnpInterface];
        
        [self updateWeMos];
    });
    
    if ( !doInBackground ) {
        //just delete device groups. no need to do this in background mode
        [[self.devicesAndGroups objectAtIndex : 1] removeAllObjects];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            [self loadDeviceGroups];
        });
    }

}

- (BOOL) isWiFiConnected
{
    WeMoNetworkManager * networkManager = [WeMoNetworkManager sharedWeMoNetworkManager];
    NSString * routerSsid = [networkManager accessPoint];
    NSLog(@"ssid = %@",routerSsid);
    
    if ( ![routerSsid isEqualToString : EMPTY_STRING]
            && ([routerSsid hasPrefix : WEMO_SSID] == NO)) {
        
        [self.wifiDisconnectedAlert dismissWithClickedButtonIndex : self.wifiDisconnectedAlert.cancelButtonIndex
                                                         animated : YES];
        
        if ( ![routerSsid isEqualToString : self.currentNetworkSSId] ) {
            self.currentNetworkSSId = routerSsid;
            [self refreshDeviceList];
            //todo: revisit. since immediately calling refreshDeviceList, probably OK to do this.
            return NO;
        }
        
        return YES;
    }
    
    self.currentNetworkSSId = nil;

    //remove every device and groups
    [[self.devicesAndGroups objectAtIndex : 0] removeAllObjects];
    [[self.devicesAndGroups objectAtIndex : 1] removeAllObjects];
    [self.deviceDictionary removeAllObjects];
    
    if ( ![self isAlertsVisible] ) {
        [self.wifiDisconnectedAlert show];
    }
    
    return NO;
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
    LHDevice * device = nil;
    //todo: guard against array iob. need to refactor.
    @synchronized( self.devicesAndGroups ) {
        if ( [[self.devicesAndGroups objectAtIndex : indexPath.section] count] <= indexPath.row ) {
            cell.layer.hidden = YES;
            //refresh the collectionview
            [self performSelector : @selector(reloadDeviceList)
                       withObject : nil
                       afterDelay : 1.0];
            return cell;
        }
        
        cell.layer.hidden = NO;
        device = [[self.devicesAndGroups objectAtIndex : indexPath.section]
                                         objectAtIndex : indexPath.row];
    }
    
    cell.nameLabel.text = device.friendlyName;
    cell.image.image = device.displayImage;
    
    if ( [device isKindOfClass : [LHDeviceGroup class]] ) {
        cell.infoButton.hidden  = NO;
        cell.infoButtonCallback = ^{
            self.selectedDevice = device;
            NSLog ( @"device info %@", device.friendlyName );
        
        
            [self performSegueWithIdentifier : LHPushGroupForEditSegueIdentifier
                                      sender : self];
        
        };
    } else {
        cell.infoButton.hidden  = YES;
    }

    cell.toggleCallbackBlock = ^{
        [(id <LHToogleHandler>) device toggle];
    };
    
    [cell addObserverForDevice : device];
    
    return cell;
}

- (UICollectionReusableView *) collectionView : (UICollectionView *) collectionView
            viewForSupplementaryElementOfKind : (NSString *) kind
                                  atIndexPath : (NSIndexPath *) indexPath
{
    UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader
                                                                               withReuseIdentifier : @"DeviceCollectionHeader"
                                                                                      forIndexPath : indexPath];
    // no groups available. hide the header bar
    if ([[self.devicesAndGroups objectAtIndex : 1] count] == 0) headerView.hidden = YES;
    else headerView.hidden = NO;
    return headerView;
}

#pragma mark - Collection view delegate
- (void) collectionView : (UICollectionView *) collectionView didSelectItemAtIndexPath : (NSIndexPath *) indexPath
{
    NSLog ( @"item selected at %@", indexPath );
    
    LHDeviceCell * cell = (LHDeviceCell *) [collectionView cellForItemAtIndexPath : indexPath];
    
    [cell animate];
    cell.toggleCallbackBlock();
}

#pragma mark - Navigation

-(void) prepareForSegue : (UIStoryboardSegue *) segue sender : (id) sender
{
    if ( [[segue identifier] isEqualToString : LHPushGroupForCreateSegueIdentifier] ) {
        LHGroupCRUDViewController * targetViewController =
            (LHGroupCRUDViewController *) segue.destinationViewController;
        
        LHAppDelegate * appDelegate = (LHAppDelegate *) [[UIApplication sharedApplication] delegate];
        
        DeviceGroup * deviceGroup = [NSEntityDescription insertNewObjectForEntityForName : @"DeviceGroup"
                                                                  inManagedObjectContext : appDelegate.managedObjectContext];
        
        [targetViewController initializeWithDevices : [self.devicesAndGroups objectAtIndex : 0]
                                    withDeviceGroup : deviceGroup
                                         isNewGroup : YES];

    } else if ( [[segue identifier] isEqualToString : LHPushGroupForEditSegueIdentifier] ) {
        LHGroupCRUDViewController * targetViewController =
        (LHGroupCRUDViewController *) segue.destinationViewController;
        
        [targetViewController initializeWithDevices : [self.devicesAndGroups objectAtIndex : 0]
                                    withDeviceGroup : ((LHDeviceGroup *) self.selectedDevice).managedDeviceGroup
                                         isNewGroup : NO];
    }
    
}

#pragma mark - WeMo Discovery Delegate
- (void) discoveryManager : (WeMoDiscoveryManager *) manager
           didFoundDevice : (WeMoControlDevice *) device
{
    NSLog(@"didFound Wemo Device ");
    
    LHWeMoSwitch * wemoSwitch = [self.deviceDictionary objectForKey : device.udn];
    //already discovered. just update. todo: OOP
    if ( wemoSwitch != nil ) {
        [wemoSwitch updateWithWeMoControlDevice : device];
        
        [self reloadDeviceList];
        return;
    }
        
        //Insight devices have 3 states (ON/OFF/IDLE. So called a separate UPnP method to handle IDLE state. Insight device type is 2 as mentioned in DeviceConfigData.plist file.)
       // if (device.deviceType == 2)
        //{
            //todo
            //[self getStatusForInsightDevice:device];
        //}
        
    LHWeMoSwitch * weMoDevice = [[LHWeMoSwitch alloc] initWithWeMoControlDevice : device];
    [self addDeviceToList : weMoDevice];
}

-(void)discoveryManager : (WeMoDiscoveryManager *) manager
    removeDeviceWithUdn : (NSString*) udn {
    
    [self removeDeviceFromList : udn];
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

-(void) didNetworkChanged : (NSNotification *) notification
{
}

-(void) searchForDevices : (NSNotification *) notification {
    NSLog(@"search for devices");
    [self searchForBridgeLocal];
    //no need to start wemo search, as they will be called periodically. 
}


#pragma mark - HueSDK

/**
 Notification receiver for successful local connection
 */
- (void)localConnection {
    // Check current connection state
    NSLog ( @"localConnection" );
    
    //first time after refresh
    if ( self.hueHeartbeatDelay != REGULAR_HUE_HEARTBEAT_DELAY ) {
        self.hueHeartbeatDelay = REGULAR_HUE_HEARTBEAT_DELAY;
        
        [self disableLocalHeartbeat];
        [self performSelector : @selector(enableLocalHeartbeat:)
                   withObject : @REGULAR_HUE_HEARTBEAT_DELAY
                   afterDelay : 1];
    }
    [self updateHueLights];
    
}

- (void) updateHueLights {
    if ( ![[LHAppDelegate getHueSDK] localConnected] ) return;
    
    PHBridgeResourcesCache * cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    for (PHLight * light in cache.lights.allValues) {
        if ( [light.lightState.reachable boolValue] ) {
            LHHueBulb * discoveredHueBulb = [self.deviceDictionary objectForKey : light.identifier];
            
            if ( discoveredHueBulb == nil ) {
                NSLog ( @"light: %@", light.name );
                LHHueBulb * hueBulb = [[LHHueBulb alloc] initWithPHLight : light];
            
                [self addDeviceToList : hueBulb];
            } else {
                //already discovered. just update. todo: OOP
                [discoveredHueBulb updateWithPHLight : light];
                    
                [self reloadDeviceList];
            }
        } else {
            //the bulb is not reachable anymore
            [self removeDeviceFromList : light.identifier];
        }
    }

}

- (void) updateWeMos {
    NSMutableArray * devices = [self.devicesAndGroups objectAtIndex : 0];
    
    for ( int i = 0; i < devices.count; i++ ) {
        if ( [devices[i] isKindOfClass : [LHWeMoSwitch class]]) {
            LHWeMoSwitch * wemoDevice = (LHWeMoSwitch *) devices[i];
            WeMoControlDevice * WeMoControlDevice = wemoDevice.weMoControlDevice;
            
            if (WeMoControlDevice.state == WeMoDeviceUndefinedState) {
                [self removeDeviceFromList : wemoDevice.identifier];
            }
        }
    }
}

- (void) loadDeviceGroups
{
    NSManagedObjectContext * context = ((LHAppDelegate *)
                                        [[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName : @"DeviceGroup"];
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest : request error : &error];
    
    if ( error == nil ) {
        for ( DeviceGroup * managedDeviceGroup  in results ) {
            NSLog(@"Name: %@", managedDeviceGroup.name);
            LHDeviceGroup * deviceGroup = [[LHDeviceGroup alloc]
                                           initWithManagedDeviceGroup : managedDeviceGroup
                                           withDeviceDictionary : self.deviceDictionary];
            
            @synchronized( self.devicesAndGroups ) {
                NSMutableArray * deviceGroups = [self.devicesAndGroups objectAtIndex : 1];
                [deviceGroups addObject : deviceGroup];
            }
            
            [self reloadDeviceList];
        }
        
    }
    else {
        
        //todo: deal with error
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
    
    [self disableLocalHeartbeat];
    
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
  
    // Remove pushlink view controller
    [self.navigationController dismissViewControllerAnimated : YES completion : nil];
    self.pushLinkViewController = nil;
    
    // Start local heartbeat
    [self performSelector : @selector(enableLocalHeartbeat)
               withObject : nil
               afterDelay : 1];
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
        [self.hueHubNotAuthenticatedAlert show];
    }
 
}

#pragma mark - Heartbeat control

/**
 Starts the local heartbeat with a 1 second interval
 */

- (void)enableLocalHeartbeat
{
    [self enableLocalHeartbeat : @INITIAL_HUE_HEARTBEAT_DELAY];
}

- (void)enableLocalHeartbeat : (NSNumber*) withDelay {
    @synchronized ( self.isHueHeartbeatEnabled ) {
        if ( [self.isHueHeartbeatEnabled isEqualToString : @"YES"]) return;
        
        self.isHueHeartbeatEnabled = @"YES";
    }
    
    self.hueHeartbeatDelay = [withDelay intValue];
    /***************************************************
     The heartbeat processing collects data from the bridge
     so now try to see if we have a bridge already connected
     *****************************************************/
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    if ( cache != nil && cache.bridgeConfiguration != nil
        && cache.bridgeConfiguration.ipaddress != nil ) {
        
        [[LHAppDelegate getHueSDK] enableLocalConnectionUsingInterval:self.hueHeartbeatDelay];
    } else {
        // Automaticly start searching for bridges
        [self searchForBridgeLocal];
    }
}

/**
 Stops the local heartbeat
 */
- (void)disableLocalHeartbeat {
    @synchronized ( self.isHueHeartbeatEnabled ) {
        self.isHueHeartbeatEnabled = @"NO";
    }
    
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
        }
        
        [self performSelector : @selector(enableLocalHeartbeat)
                   withObject : nil
                   afterDelay : 1];
    }];
}

- (void) addDeviceToList : (LHDevice *) aDevice
{
    @synchronized ( self.devicesAndGroups ) {
        //guard against race condition
        if ( [self.deviceDictionary objectForKey : aDevice.identifier] ) return;
        
        NSMutableArray * devices = [self.devicesAndGroups objectAtIndex : 0];
        [devices addObject : aDevice];
        [self.deviceDictionary setObject : aDevice
                                  forKey : aDevice.identifier];
    }
    
    [self reloadDeviceList];
}

- (void) removeDeviceFromList : (NSString *) withDeviceIdentifier
{
    @synchronized ( self.devicesAndGroups ) {
        LHDevice * device = [self.deviceDictionary objectForKey : withDeviceIdentifier];
        if ( device == nil ) return;
        
        NSMutableArray * devices = [self.devicesAndGroups objectAtIndex : 0];
        [devices removeObject : device];
        [self.deviceDictionary removeObjectForKey : withDeviceIdentifier];
    }
    
    [self reloadDeviceList];
}

#pragma mark alert view delegate
- (void)alertView : (UIAlertView *) alertView didDismissWithButtonIndex : (NSInteger) buttonIndex
{
    //todo: find a common path for manual and automatic dismissal.
    if ( [alertView isKindOfClass : [LHAlertView class]] ) {
        ((LHAlertView *) alertView).isAlertViewVisible = false;
    }
    
    if ( alertView == self.wifiDisconnectedAlert
        && buttonIndex == 0 ) {
        [self refreshDeviceList];
    } else if ( alertView == self.hueHubNotAuthenticatedAlert ) {
        if ( buttonIndex != 0 ) {
            [self notAuthenticated];
        }
        else {
            [self disableLocalHeartbeat];
        }
    } if ( alertView == self.noDeviceAvailableAlert
          && buttonIndex == 0 ) {
        [self refreshDeviceList];
    }
}

- (void) listenForHueNotifications : (BOOL) doListen
{
    PHNotificationManager * notificationManager = [PHNotificationManager defaultManager];
    
    if ( doListen ) {
        /***************************************************
         The SDK will send the following notifications in response to events
         *****************************************************/
        
        [notificationManager registerObject : self
                               withSelector : @selector ( localConnection )
                            forNotification : LOCAL_CONNECTION_NOTIFICATION];
        [notificationManager registerObject : self
                               withSelector : @selector ( noLocalConnection )
                            forNotification : NO_LOCAL_CONNECTION_NOTIFICATION];
        [notificationManager registerObject : self
                               withSelector : @selector ( notAuthenticated )
                            forNotification : NO_LOCAL_AUTHENTICATION_NOTIFICATION];
        
        [self enableLocalHeartbeat];
        
    } else {
        [notificationManager deregisterObjectForAllNotifications : self];
    }
    
}

- (void) checkAppStatus
{
    if ( [self isWiFiConnected] ) {
        if ( self.deviceDictionary.count == 0 ) {
            self.addGroupBarButton.enabled = NO;
            //todo: needs refactor. central hub
            if ( !self.pushLinkViewController
                && ![self isAlertsVisible] ) {
                [self.noDeviceAvailableAlert show];
            }
        }
        
        [self refreshDeviceList : YES];
    }
}

@end
