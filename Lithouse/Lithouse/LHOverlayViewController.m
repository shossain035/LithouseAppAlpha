//
//  LHOverlayViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 7/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHOverlayViewController.h"

@interface LHOverlayViewController ()

@property (nonatomic, strong) IBOutlet UIView  * mainView;

@end

@implementation LHOverlayViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (!self) return self;
    
    [self setModalPresentationStyle:UIModalPresentationCustom];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize = self.mainView.frame.size;
}


@end
