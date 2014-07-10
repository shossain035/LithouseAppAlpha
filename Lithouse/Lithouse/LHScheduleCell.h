//
//  LHScheduleCell.h
//  Lithouse
//
//  Created by Shah Hossain on 6/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHCollectionViewCell.h"

@interface LHScheduleCell : LHCollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel  * timeHourMinuteLabel;
@property (nonatomic, strong) IBOutlet UILabel  * timeAMPMLabel;
@property (nonatomic, strong) IBOutlet UILabel  * actionLabel;
@property (nonatomic, strong) IBOutlet UILabel  * recurranceLabel;



@end
