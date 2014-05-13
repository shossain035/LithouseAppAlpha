//
//  LHDevice.h
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHDevice : NSObject

@property (nonatomic, strong) NSString       * friendlyName;
@property (nonatomic, strong) UIImage        * displayImage;
@property (nonatomic, strong) NSMutableArray * permissibleActions;

@end
