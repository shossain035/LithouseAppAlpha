//
//  LHMainMenuViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 5/10/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"

typedef NS_ENUM(NSUInteger, LHPaneViewControllerType) {
    LHPaneViewControllerTypeDevicesAndTriggers,
    LHPaneViewControllerTypeContactUs,
    LHPaneViewControllerTypeAbout
};


@interface LHMainMenuViewController : UITableViewController

@property (nonatomic, assign) LHPaneViewControllerType         paneViewControllerType;
@property (nonatomic, weak)   MSDynamicsDrawerViewController * dynamicsDrawerViewController;

- (void) transitionToViewController : (LHPaneViewControllerType) paneViewControllerType;

@end
