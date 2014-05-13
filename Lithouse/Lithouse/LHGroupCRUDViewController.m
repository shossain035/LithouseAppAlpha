//
//  LHGroupCRUDViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHGroupCRUDViewController.h"
#import "LHGroupDeviceTableViewCell.h"

@interface LHGroupCRUDViewController ()

@property (nonatomic, strong) IBOutlet UITableView * deviceTableView;

@end

@implementation LHGroupCRUDViewController

- (IBAction) cancel : (id) sender
{
    NSLog( @"Cancel clicked" );
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) save : (id) sender
{
    NSLog( @"Save clicked" );
    [self.navigationController popViewControllerAnimated:YES];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.deviceTableView.tableFooterView = [[UIView alloc] initWithFrame : CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView : (UITableView *) tableView
{
    return 1;
}

- (NSInteger) tableView : (UITableView *) tableView
  numberOfRowsInSection : (NSInteger) section
{
    return 2;
}


 - (UITableViewCell *) tableView : (UITableView *) tableView
           cellForRowAtIndexPath : (NSIndexPath *) indexPath
 {
     LHGroupDeviceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier : @"GroupDeviceCell"
                                                                         forIndexPath : indexPath];
 
     cell.deviceNameLabel.text = @"device1";
     return cell;
 }

@end
