//
//  LHCloudApiClient.h
//  Lithouse
//
//  Created by Shah Hossain on 8/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHCloudApiClient : NSObject
+ (void) postToCloudResourceWithEndpoint:(NSString *) resourceEndpoint
                    withData:(NSString *) data
                  completion:(void(^)(NSHTTPURLResponse *, NSError *))callback;
@end