//
//  LHDeviceCell.m
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHDeviceCell.h"
#import "LHAppDelegate.h"

@interface LHDeviceCell ()
@property (strong, nonatomic) id statusChangeObserver;
@end

@implementation LHDeviceCell

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

- (void) addObserverForDevice : (LHDevice *) aDevice
{
    [[NSNotificationCenter defaultCenter] removeObserver : self.statusChangeObserver];
    
    self.statusChangeObserver = [[NSNotificationCenter defaultCenter]
        addObserverForName : LHDeviceDidStatusChangeNotification
        object             : aDevice
        queue              : [NSOperationQueue mainQueue]
        usingBlock         : ^ (NSNotification * notification)
        {
            NSDictionary * statusData = notification.userInfo;
            self.backgroundColor = [UIColor whiteColor];
            LHDeviceStatus status = [[statusData objectForKey : LHDeviceDidStatusChangeNotification]
                                     intValue];
            
            UIImage * deviceImage = [[aDevice class] imageForStatus:status];
            if ( deviceImage != nil ) {
                self.image.image = deviceImage;
            }
                
            if ( status == LHDeviceIsOn ) {
                
                self.backgroundColor = [UIColor colorWithRed : 0.74991234038415455f
                                                       green : 1.0f
                                                        blue : 0.78419363416042009f
                                                       alpha : 1.0f];
                
            } else if ( status == LHDeviceIsUnPaired ) {
                self.backgroundColor = [UIColor lightGrayColor];
                
            }
            
        }
    ];
    
    [aDevice notifyCurrentStatus];
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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.statusChangeObserver];
}

@end
