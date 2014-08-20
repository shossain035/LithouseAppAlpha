//
//  LHCloudApiClient.m
//  Lithouse
//
//  Created by Shah Hossain on 8/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHCloudApiClient.h"
#define LITHOUSE_API_URL           @"http://api.lithouse.co/v1/"

@implementation LHCloudApiClient

+ (void) postToCloudResourceWithEndpoint:(NSString *) resourceEndpoint
                                withData:(NSString *) data
                              completion:(void(^)(NSHTTPURLResponse *, NSError *))callback
{
//    NSLog(@"data %@", data);
    NSURL * url = [NSURL URLWithString:
                   [NSString stringWithFormat : @"%@%@", LITHOUSE_API_URL, resourceEndpoint]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json; charset=utf-8"
   forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
     {
//         if ( data.length > 0 && connectionError == nil ) {
//             NSLog(@"response %@", response);
//         } else {
//             NSLog(@"response %@, error %@", response, connectionError);
//         }
//         
         
         callback((NSHTTPURLResponse *)response, connectionError);
     }];

}

@end

