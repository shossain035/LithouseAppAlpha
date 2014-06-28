//
//  LHRepeatViewController.m
//  Lithouse
//
//  Created by Shah Hossain on 6/27/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHRepeatViewController.h"

@interface LHRepeatViewController ()
@property (nonatomic, strong) NSArray * weekdays;
@end

@implementation LHRepeatViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
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

    self.weekdays = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    
    if ( self.selectedWeekdays == nil ) {
        self.selectedWeekdays = [@[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO] mutableCopy];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekdayCell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Every %@",
                           self.weekdays[indexPath.row]];
    
    if ([self.selectedWeekdays[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void) tableView : (UITableView *) tableView didSelectRowAtIndexPath : (NSIndexPath *) indexPath
{
    self.selectedWeekdays[indexPath.row] = @([self.selectedWeekdays[indexPath.row] boolValue] ^ YES);
    [self.tableView reloadData];
}


- (IBAction) back : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
