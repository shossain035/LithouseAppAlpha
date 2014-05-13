//
//  LHGroupDeviceTableViewCell.h
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHGroupDeviceTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton * selectionButton;
@property (nonatomic, strong) IBOutlet UIButton * actionPickerButton;
@property (nonatomic, strong) IBOutlet UILabel  * deviceNameLabel;

@property                              BOOL       isSelected;

@end
