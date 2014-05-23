//
//  LHDevice.h
//  Lithouse
//
//  Created by Shah Hossain on 5/11/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHToggle.h"


@interface LHDevice : NSObject <LHToogleHandler>

@property (nonatomic, strong) NSString            * friendlyName;
@property (nonatomic, strong) UIImage             * displayImage;
@property (nonatomic, strong) NSMutableDictionary * permissibleActions;

- (NSString *) identifier;
- (void) addToPermissibleActions : (LHAction *) aAction;

@end
