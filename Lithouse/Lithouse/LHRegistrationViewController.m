//
//  LHRegistrationViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 8/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHRegistrationViewController.h"
#import "LHTextInputOverlayViewController.h"
#import "LHSignupInputDelegate.h"
#import "LHLoginInputDelegate.h"
#import "LHOverlayTransitioner.h"

#define kTextInputOverlayViewControllerId     @"LHTextInputOverlayViewController"

@interface LHRegistrationViewController ()
{
     id<UIViewControllerTransitioningDelegate> _transitioningDelegate;
}


@property (nonatomic, strong) IBOutlet UIButton       * loginButton;

@end

@implementation LHRegistrationViewController

- (IBAction) registerButtonTouched:(id) sender
{
    LHTextInputOverlayViewController *overlay = [self.storyboard
                                        instantiateViewControllerWithIdentifier:kTextInputOverlayViewControllerId];
    overlay.delegate = [[LHSignupInputDelegate alloc] init];
    [self showOverlay:overlay];
}

- (IBAction) loginButtonTouched:(id) sender
{
    LHTextInputOverlayViewController *overlay = [self.storyboard
                                                 instantiateViewControllerWithIdentifier:kTextInputOverlayViewControllerId];
    overlay.delegate = [[LHLoginInputDelegate alloc] init];
    [self showOverlay:overlay];
}


- (void) showOverlay:(LHOverlayViewController *) overlayController
{
    _transitioningDelegate = [[LHOverlayTransitioningDelegate alloc] init];
    [overlayController setTransitioningDelegate: _transitioningDelegate];
    
    [self presentViewController:overlayController animated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.borderWidth = 1.0f;
    self.loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
}

@end
