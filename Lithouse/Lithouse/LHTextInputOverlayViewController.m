//
//  LHTextInputOverlayViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 8/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHTextInputOverlayViewController.h"

@interface LHTextInputOverlayViewController () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField * inputTextField;
@property (nonatomic, strong) IBOutlet UILabel     * messageLabel;

@end

@implementation LHTextInputOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.inputTextField.placeholder = [self.delegate placeholder];
    [self.inputTextField becomeFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self. view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate processInput:textField.text withMessageLabel:self.messageLabel];
    return YES;
}

- (BOOL) textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
 replacementString:(NSString *)string
{
    self.messageLabel.hidden = YES;
    
    return YES;
}

+ (void) showMessage:(NSString *) messageText toLabel:(UILabel *) targetLabel isError:(BOOL) isError
{
    targetLabel.hidden = false;
    targetLabel.textColor = isError ? [UIColor redColor] : [UIColor blackColor];
    targetLabel.text = messageText;
}

@end
