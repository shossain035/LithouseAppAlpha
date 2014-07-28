//
//  DeviceGroup.m
//  Lithouse
//
//  Created by Shah Hossain on 5/21/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "DeviceGroup.h"


@implementation DeviceGroup

@dynamic name;
@dynamic uuid;
@dynamic type;
@dynamic image;
@dynamic actions;


- (void) awakeFromInsert
{
    self.name = @"All On";
    self.image = UIImagePNGRepresentation ( [UIImage imageNamed : @"generic_group"] );
}

@end
