//
//  LHOverlayPresentationController.m
//  Lithouse
//
//  Created by Shah Hossain on 7/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHOverlayPresentationController.h"

@implementation LHOverlayPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if(self)
    {
        [self prepareDimmingView];
    }
    
    return self;
}

- (void)presentationTransitionWillBegin
{
    UIView* containerView = [self containerView];
    UIViewController* presentedViewController = [self presentedViewController];
    [dimmingView setFrame:[containerView bounds]];
    
    [dimmingView setAlpha:0.0];
    
    [containerView insertSubview:dimmingView atIndex:0];
    
    if([presentedViewController transitionCoordinator])
    {
        [[presentedViewController transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [dimmingView setAlpha:1.0];
        } completion:nil];
    }
    else
    {
        [dimmingView setAlpha:1.0];
    }
}

- (void)dismissalTransitionWillBegin
{
    if([[self presentedViewController] transitionCoordinator])
    {
        [[[self presentedViewController] transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            [dimmingView setAlpha:0.0];
        } completion:nil];
    }
    else
    {
        [dimmingView setAlpha:0.0];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyle
{
    return UIModalPresentationOverFullScreen;
}

- (CGSize)sizeForChildContentContainer:(id <UIContentContainer>)container withParentContainerSize:(CGSize)parentSize
{
    return CGSizeMake(parentSize.width,
                      container.preferredContentSize.height);
}

- (void)containerViewWillLayoutSubviews
{
    [dimmingView setFrame:[[self containerView] bounds]];
    [[self presentedView] setFrame:[self frameOfPresentedViewInContainerView]];
}

- (BOOL)shouldPresentInFullscreen
{
    return NO;
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect presentedViewFrame = CGRectZero;
    CGRect containerBounds = [[self containerView] bounds];
    
    presentedViewFrame.size = [self sizeForChildContentContainer:(UIViewController<UIContentContainer> *)[self presentedViewController]
                                         withParentContainerSize:containerBounds.size];
    
    presentedViewFrame.origin.y = containerBounds.size.height - presentedViewFrame.size.height;
    
    return presentedViewFrame;
}

@synthesize dimmingView;

- (void)prepareDimmingView
{
    dimmingView = [[UIView alloc] init];
    [dimmingView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
    [dimmingView setAlpha:0.0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)];
    [dimmingView addGestureRecognizer:tap];
}

- (void)dimmingViewTapped:(UIGestureRecognizer *)gesture
{
    if([gesture state] == UIGestureRecognizerStateRecognized)
    {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
