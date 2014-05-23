//
//  LHGroupDeviceTableViewCell.h
//  Lithouse
//
//  Created by Shah Hossain on 5/12/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LHDeviceCellActionPickerCallbackBlock)    (void);
typedef void (^LHDeviceCellSelectionButtonCallbackBlock) (BOOL);


@interface LHGroupDeviceTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *         selectionButton;
@property (nonatomic, strong) IBOutlet UIButton *         actionPickerButton;
@property (nonatomic, strong) IBOutlet UILabel  *         deviceNameLabel;

@property                              BOOL               isSelected;
@property (copy) LHDeviceCellActionPickerCallbackBlock    actionPickerCallback;
@property (copy) LHDeviceCellSelectionButtonCallbackBlock selectionButtonCallback;

- (void) selectDevice : (BOOL) didSelect;

@end
