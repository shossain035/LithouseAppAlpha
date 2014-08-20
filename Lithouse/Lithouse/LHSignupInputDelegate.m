//
//  LHRegistrationInputDelegate.m
//  Lithouse
//
//  Created by Shah Hossain on 8/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHSignupInputDelegate.h"
#import "LHCloudApiClient.h"

@implementation LHSignupInputDelegate

-(NSString *) placeholder
{
    return @"Email Address";
}

- (void) processInput:(NSString *) inputText
     withMessageLabel:(UILabel *) messageLabel
{
    if (![self isValidEmail:inputText]) {
        [LHTextInputOverlayViewController showMessage:@"Invalid Email Address"
                                              toLabel:messageLabel
                                              isError:YES];
        return;
    }
    
    [LHCloudApiClient
     postToCloudResourceWithEndpoint:@"signups"
                            withData:[NSString stringWithFormat : @"{\"emailAddress\":\"%@\",\"deviceType\":\"%@\"}",
                                      inputText, [UIDevice currentDevice].model]
                          completion:^(NSHTTPURLResponse * response, NSError * connectionError) {
                              if (connectionError) {
                                  [LHTextInputOverlayViewController showMessage:@"Sorry! Failed to sign up. Please try later."
                                                                        toLabel:messageLabel
                                                                        isError:YES];
                                  return;
                              }
         
                              if (response.statusCode == 400) {
                                  [LHTextInputOverlayViewController showMessage:@"Invalid Email Address"
                                                                        toLabel:messageLabel
                                                                        isError:YES];
                                  return;
                              }
         
                              [LHTextInputOverlayViewController showMessage:@"Thank you! We will be in touch soon."
                                                                    toLabel:messageLabel
                                                                    isError:NO];
                              
     }];
}

- (BOOL) isValidEmail:(NSString*) emailString {
    
    if ([emailString length]==0) {
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString
                                                     options:0
                                                       range:NSMakeRange(0, [emailString length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}


@end
