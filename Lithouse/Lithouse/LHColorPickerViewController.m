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
//todo: remove
@property (nonatomic, weak) IBOutlet UIButton *button;
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
        //todo: only after touch released
        [weakSelf changeLightColor:color];
    }];
    
    [self.pickerView setTintColor:[[[[UIApplication sharedApplication] delegate] window] tintColor]];
    
}

-(void) changeLightColor:(UIColor *) toColor
{
    NSLog(@"new color: %@", toColor);
    self.button.backgroundColor = self.pickerView.color;
    [self.light updateColor:toColor];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"color : %@", [self.light getCurrentColor]);
    [self.pickerView setColor:[self.light getCurrentColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
