//
//  LHColorPickerViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 6/13/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHColorPickerViewController.h"
#import "NKOColorPickerView.h"

@interface LHColorPickerViewController ()

@property (nonatomic, weak) IBOutlet NKOColorPickerView * pickerView;
@end

@implementation LHColorPickerViewController

- (IBAction) back : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak LHColorPickerViewController * weakSelf = self;
    
    [self.pickerView setDidChangeColorBlock:^(UIColor *color) {
        [weakSelf changeLightColor:color];
    }];
    
    [self.pickerView setTintColor:[UIColor lightGrayColor]];
    
}

-(void) changeLightColor:(UIColor *) toColor
{
    [self.light updateColor:toColor];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pickerView setColor:[self.light getCurrentColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
