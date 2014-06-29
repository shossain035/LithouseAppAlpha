//
//  LHScheduleCell.h
//  Lithouse
//
//  Created by Shah Hossain on 6/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LHScheduleEnableValueChanged) (BOOL);

@interface LHScheduleCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel  * dateLabel;
@property (nonatomic, strong) IBOutlet UILabel  * actionLabel;
@property (nonatomic, strong) IBOutlet UILabel  * recurranceLabel;
@property (nonatomic, strong) IBOutlet UISwitch * enableSwitch;
@property (copy) LHScheduleEnableValueChanged     enableValueChangedCallback;


@end
