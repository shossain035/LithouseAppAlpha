//
//  LHCollectionViewCell.m
//  Lithouse
//
//  Created by Shah Hossain on 6/30/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHCollectionViewCell.h"

@implementation LHCollectionViewCell

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder : aDecoder] ) {
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(-1, 1);
        self.layer.shadowOpacity = 0.10;
    }
    
    return self;
}

- (IBAction) infoButtonTapped : (id) sender
{
    NSLog ( @"info button tapped" );
    self.infoButtonCallback();
}

- (void) animate
{
    CABasicAnimation * shadowAnimation = [CABasicAnimation animationWithKeyPath : @"shadowOpacity"];
    shadowAnimation.fromValue = [NSNumber numberWithFloat : self.layer.shadowOpacity];
    shadowAnimation.toValue = [NSNumber numberWithFloat : 0.7f];
    shadowAnimation.repeatCount = 1.0;
    shadowAnimation.autoreverses = YES;
    shadowAnimation.duration = 0.15f;
    
    [self.layer addAnimation : shadowAnimation forKey : @"shadowOpacity"];
}

- (void) toggle
{
    [self animate];
    self.toggleCallbackBlock ();
}

- (void) activate : (BOOL) isActive
{
    if ( isActive ) {
        
        self.backgroundColor = [UIColor colorWithRed : 0.74991234038415455f
                                               green : 1.0f
                                                blue : 0.78419363416042009f
                                               alpha : 1.0f];
        
    } else {
        self.backgroundColor = [UIColor whiteColor];
        
    }
}

@end
