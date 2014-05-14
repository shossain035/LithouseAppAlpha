//
//  LHModalPickerViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 5/14/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHModalPickerViewController.h"

@interface LHModalPickerViewController ()

@end

@implementation LHModalPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView : (UITableView *) tableView
  numberOfRowsInSection : (NSInteger) section
{
    if (self.numberOfRowsCallback == nil) return 0;
    
    return self.numberOfRowsCallback();
}


- (UITableViewCell *) tableView : (UITableView *) tableView
          cellForRowAtIndexPath : (NSIndexPath *) indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier : @"ModalPickerCell"
                                                             forIndexPath : indexPath];
    
    self.updateCellAtIndexPathCallback ( cell, indexPath );
    return cell;
}

#pragma mark - Table view delegate
- (void) tableView : (UITableView *) tableView didSelectRowAtIndexPath : (NSIndexPath *) indexPath
{
    [self dismissViewControllerAnimated : YES completion : nil];
    self.didSelectRowAtIndexPathCallback ( indexPath );
}

@end
