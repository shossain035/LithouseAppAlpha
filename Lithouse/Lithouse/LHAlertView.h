//
//  UIAlertView+LHBlockAdditions.h
//  Lithouse
//
//  Created by Shah Hossain on 5/25/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHAlertView : UIAlertView

@property (copy, nonatomic) void (^completion) (BOOL, NSInteger);

- (id) initWithTitle : (NSString *) title
             message : (NSString *) message
   cancelButtonTitle : (NSString *) cancelButtonTitle
   otherButtonTitles : (NSArray *) otherButtonTitles;

@end
