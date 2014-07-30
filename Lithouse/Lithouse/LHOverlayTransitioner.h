//
//  LHOverlayTransitioner.h
//  Lithouse
//
//  Created by Shah Hossain on 7/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

@import UIKit;

@interface LHOverlayAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) BOOL isPresentation;
@end

@interface LHOverlayTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>
@end