//
//  LHAppDelegate.h
//  Lithouse
//
//  Created by Shah Hossain on 5/10/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeMoStateManager.h"

@class MSDynamicsDrawerViewController;
@interface LHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

//WeMo SDK reference
@property (nonatomic, copy) WeMoStateManager * stateManager;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
