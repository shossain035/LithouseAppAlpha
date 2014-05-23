//
//  DeviceGroup.h
//  Lithouse
//
//  Created by Shah Hossain on 5/21/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DeviceGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSMutableDictionary * actions;

@end
