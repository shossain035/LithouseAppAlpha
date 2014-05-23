//
//  LHGroupDeviceTableViewCell.m
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHGroupDeviceTableViewCell.h"

@implementation LHGroupDeviceTableViewCell

- (IBAction) didTapSelectionButton : (id) sender
{
    self.isSelected = !self.isSelected;
    [self selectDevice : self.isSelected];
}

- (IBAction) didTapActionPickerButton : (id) sender
{
    self.actionPickerCallback();
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) selectDevice : (BOOL) didSelect
{
    self.isSelected = didSelect;
    if ( self.isSelected ) {
        [self.selectionButton setImage : [UIImage imageNamed : @"Checked"] forState : UIControlStateNormal];
    } else {
        [self.selectionButton setImage : [UIImage imageNamed : @"Unchecked"] forState : UIControlStateNormal];
    }
    
    self.selectionButtonCallback ( self.isSelected );
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected : (BOOL)selected animated : (BOOL)animated
{
    //[self toggleSelectionButton];
}

@end
