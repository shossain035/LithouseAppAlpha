//
//  LHSupportedDevicesWebViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 9/8/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHSupportedDevicesWebViewController.h"

@interface LHSupportedDevicesWebViewController ()

@property (strong, nonatomic) IBOutlet UIWebView * webView;

@end

@implementation LHSupportedDevicesWebViewController


- (IBAction) back:(id) sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *strURL = @"http://www.litehouse.io/#!devices/c21tk";
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
