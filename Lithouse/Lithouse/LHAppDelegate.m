//
//  LHAppDelegate.m
//  Lithouse
//
//  Created by Shah Hossain on 5/10/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHAppDelegate.h"
#import "LHMainMenuViewController.h"
#import "MSDynamicsDrawerViewController.h"
#import "MSDynamicsDrawerStyler.h"
#import "WeMoNetworkManager.h"
#import "License.h"

@interface LHAppDelegate ()
@property (readonly, strong, nonatomic) PHHueSDK * phHueSDK;

@end

@implementation LHAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize stateManager;
@synthesize phHueSDK;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self launchMainApp];
//    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName : @"License"];
//    NSError * error = nil;
//    NSArray * results = [self.managedObjectContext executeFetchRequest : request error : &error];
//    
//    if ( error == nil ) {
//        for ( License * license  in results ) {
//            NSLog(@"registrationDate: %@", license.registrationDate);
//            //todo: check against expiration date
//            [self launchMainApp];
//            return YES;
//        }
//        
//    } else {
//        NSLog(@"error: %@", error);
//    }
    return YES;
}

- (void) launchMainApp
{
    [[UIApplication sharedApplication] setStatusBarHidden : NO];
    //[self.window.rootViewController.navigationController popToRootViewControllerAnimated:NO];
    //[self.window.rootViewController dismissViewControllerAnimated:NO completion:NULL];
    
    self.dynamicsDrawerViewController
        = (MSDynamicsDrawerViewController *) [self.window.rootViewController.storyboard
                                              instantiateViewControllerWithIdentifier : @"DynamicDrawer"];
    
    [UIView transitionWithView:self.window
                      duration:0.65
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.window.rootViewController = self.dynamicsDrawerViewController;
                    }
                    completion:nil];

    self.dynamicsDrawerViewController.paneDragRequiresScreenEdgePan = YES;
    //stopping unintented exposure
    [self.dynamicsDrawerViewController registerTouchForwardingClass:[UICollectionViewCell class]];
    // Add some example stylers
    [self.dynamicsDrawerViewController addStylersFromArray : @[[MSDynamicsDrawerScaleStyler styler],
                                                               [MSDynamicsDrawerFadeStyler styler],
                                                               [MSDynamicsDrawerParallaxStyler styler]]
                                              forDirection : MSDynamicsDrawerDirectionLeft];
    
    LHMainMenuViewController * menuViewController = [self.window.rootViewController.storyboard
                                                     instantiateViewControllerWithIdentifier : @"MainMenu"];
    menuViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    
    [self.dynamicsDrawerViewController setDrawerViewController : menuViewController
                                                  forDirection : MSDynamicsDrawerDirectionLeft];
    // Transition to the first view controller
    [menuViewController transitionToViewController : LHPaneViewControllerTypeDevicesAndTriggers];

    //App wide styles
    self.window.tintColor = [UIColor colorWithRed : 0.23203192348306206f
                                            green : 0.68421157525510212f
                                             blue : 0.29434636798765151f
                                            alpha : 1.0f];
    
    //wemo state manager
    stateManager = [WeMoStateManager sharedWeMoStateManager];
    
    // Create hue sdk instance
    phHueSDK = [[PHHueSDK alloc] init];
    [phHueSDK startUpSDK];
    [phHueSDK enableLogging : NO];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [stateManager applicationWillResignActive : application];
    [[NSNotificationCenter defaultCenter] removeObserver : self
                                                    name : wemoNetworkChangeNotification
                                                  object : nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [stateManager applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [stateManager applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [stateManager applicationDidBecomeActive : application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] removeObserver : self];
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lithouse" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Lithouse.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
                                                           error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (PHHueSDK *) getHueSDK
{
    LHAppDelegate * appDelegate = (LHAppDelegate *) [[UIApplication sharedApplication] delegate];
    return [appDelegate phHueSDK];
}


@end
