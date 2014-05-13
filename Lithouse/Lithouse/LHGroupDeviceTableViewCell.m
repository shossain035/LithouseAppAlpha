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
    [self toggleSelectionButton];
}

- (IBAction) didTapActionPickerButton : (id) sender
{
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) toggleSelectionButton
{
    self.isSelected = !self.isSelected;
    if ( self.isSelected ) {
        [self.selectionButton setImage : [UIImage imageNamed : @"Checked"] forState : UIControlStateNormal];
    } else {
        [self.selectionButton setImage : [UIImage imageNamed : @"Unchecked"] forState : UIControlStateNormal];
    }
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
