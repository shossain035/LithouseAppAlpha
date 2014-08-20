//
//  License.h
//  Lithouse
//
//  Created by Shah Hossain on 8/20/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface License : NSManagedObject

@property (nonatomic, retain) NSDate   * expirationDate;
@property (nonatomic, retain) NSDate   * registrationDate;
@property (nonatomic, retain) NSString * encryptedUserId;

@end
