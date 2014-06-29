//
//  LHHomeKitController.m
//  Lithouse
//
//  Created by Shah Hossain on 6/21/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHHomeKitController.h"
#import "LHDevicesViewController.h"
#import "LHHomeKitDeviceFactory.h"
#import "LHHomeKitDevice.h"
#import <HomeKit/HomeKit.h>

static NSString * LHHomeName = @"Lithouse Home";
static const int LHHomeKitDeviceSearchDelay = 30;

@interface LHHomeKitController () <HMHomeManagerDelegate,
                                   HMAccessoryBrowserDelegate>

@property (nonatomic, weak, readonly)   id <LHDeviceViewControllerDelegate> deviceViewControllerDelegate;
@property (nonatomic, strong, readonly) HMHomeManager      *                homeManager;
@property (nonatomic, strong, readonly) HMHome             *                lithouseHome;
@property (nonatomic, strong, readonly) HMAccessoryBrowser *                accessoryBrowser;

@property (nonatomic, strong, readonly) NSMutableArray     *                unPairedDevices;

@end

@implementation LHHomeKitController

- (instancetype) initWithDeviceViewController : (id <LHDeviceViewControllerDelegate>) deviceViewControllerDelegate
{
    self = [super init];
    if ( !self ) return self;
    
    _deviceViewControllerDelegate = deviceViewControllerDelegate;
    
    _homeManager = [[HMHomeManager alloc] init];
    self.homeManager.delegate = self;
    
    _accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    self.accessoryBrowser.delegate = self;
    
    _unPairedDevices = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) startSearchingForHomeKitDevices
{
    NSLog(@"start searching for homekit devices");
    //todo: need to call exploreHomes in order to get the latest state.
    
    [self.unPairedDevices removeAllObjects];
    [self.accessoryBrowser startSearchingForNewAccessories];
    [self performSelector : @selector(stopSearchingForHomeKitDevices)
               withObject : nil
               afterDelay : LHHomeKitDeviceSearchDelay];
}

- (void) stopSearchingForHomeKitDevices
{
    NSLog(@"stop searching for homekit devices");
    
    [self.accessoryBrowser stopSearchingForNewAccessories];
    //todo: add new devices with alert
    
    
    [self.deviceViewControllerDelegate
     addUnPairedDevicesToList:self.unPairedDevices];
}

- (void) pairDevice : (LHHomeKitDevice *) aDevice
{
    [self findLithouseHome];
    
    if ( self.lithouseHome == nil ) {
        //todo: try later error
        return;
    }
        
    __weak __typeof(self) weakSelf = self;
    
    [self.lithouseHome addAccessory:aDevice.accessory
                  completionHandler:^(NSError *error) {
        if ( error != nil) {
            NSLog(@"failed to add accessory: %@, error: %@",
                  aDevice.accessory, error);
            //todo: let user know
        } else {
            [weakSelf.deviceViewControllerDelegate removeDeviceFromList:aDevice.identifier];
            //todo: cleanup
            for ( HMAccessory * accessory in weakSelf.lithouseHome.accessories ) {
                [weakSelf.deviceViewControllerDelegate addDeviceToList:
                 [LHHomeKitDeviceFactory newHomeKitDeviceWithAccessory:accessory
                                                                inHome:weakSelf.lithouseHome]];
            }
        }
    }];

}

- (void) findLithouseHome
{
    //already found
    if ( self.lithouseHome != nil ) return;
    
    //check if already created
    for (HMHome * home in self.homeManager.homes) {
        if ([home.name isEqualToString:LHHomeName]) {
            _lithouseHome = home;
            return;
        }
    }
    
    //none found. create one
    __block __typeof(self) weakSelf = self;

    [self.homeManager addHomeWithName:LHHomeName
                    completionHandler:^(HMHome *home, NSError *error) {
                        if (error == nil) {
                            NSLog( @"successfully created lithouse home");
                            weakSelf->_lithouseHome = home;
                        } else {
                            NSLog ( @"failed to add home: %@, error:%@", home, error );
                        }
                        
                    }];
    return;
}

- (void) exploreHomes
{
    for ( HMHome * home in self.homeManager.homes ) {
        for ( HMAccessory * accessory in home.accessories ) {
            if (accessory.reachable) {
                [self.deviceViewControllerDelegate addDeviceToList:
                 [LHHomeKitDeviceFactory newHomeKitDeviceWithAccessory:accessory
                                                                inHome:home]];
            }
        }
    }
}

#pragma mark home manager delegate
- (void) homeManagerDidUpdateHomes : (HMHomeManager *) manager
{
    [self findLithouseHome];
    [self exploreHomes];
}

#pragma mark accessory browser delegate

-(void) accessoryBrowser : (HMAccessoryBrowser *) browser
     didFindNewAccessory : (HMAccessory *) accessory
{
    NSLog ( @"found accessory :%@", accessory );
    [self.unPairedDevices addObject:
     [LHHomeKitDeviceFactory newHomeKitDeviceWithAccessory:accessory inHome:nil]];
}

-(void) accessoryBrowser:(HMAccessoryBrowser *)browser
   didRemoveNewAccessory:(HMAccessory *)accessory
{
    NSLog ( @"removing new accessory :%@", accessory );
}


@end
