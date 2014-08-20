//
//  LHLoginInputDelegate.m
//  Lithouse
//
//  Created by Shah Hossain on 8/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHLoginInputDelegate.h"
#import "LHCloudApiClient.h"
#import "LHAppDelegate.h"

@implementation LHLoginInputDelegate

-(NSString *) placeholder
{
    return @"Invite Code";
}

- (void) processInput:(NSString *) inputText
     withMessageLabel:(UILabel *) messageLabel
{
    if (![self isValidCode:inputText]) {
        [LHTextInputOverlayViewController showMessage:@"Invalid Code"
                                              toLabel:messageLabel
                                              isError:YES];
        return;
    }
    
    [LHCloudApiClient
     postToCloudResourceWithEndpoint:@"register"
                            withData:[NSString stringWithFormat : @"{\"code\":\"%@\",\"deviceType\":\"%@\"}",
                                      inputText, [UIDevice currentDevice].model]
                          completion:^(NSHTTPURLResponse * response, NSError * connectionError) {
                              if (connectionError) {
                                  [LHTextInputOverlayViewController showMessage:@"Sorry! Failed to log in. Please try later."
                                                                        toLabel:messageLabel
                                                                        isError:YES];
                                  return;
                              }
                                               
                              if (response.statusCode == 400) {
                                  [LHTextInputOverlayViewController showMessage:@"Invalid Code"
                                                                        toLabel:messageLabel
                                                                        isError:YES];
                                  return;
                              }
            
                              NSLog(@"logged in");
                              //save to db
                              LHAppDelegate * appDelegate = (LHAppDelegate *) [[UIApplication sharedApplication] delegate];
                              [appDelegate launchMainApp];
        
    }];
}

- (BOOL) isValidCode:(NSString*) code {
    
    if ([code length] > 1 && [code length] < 10) {
        return YES;
    }
    
    return NO;
}


@end
