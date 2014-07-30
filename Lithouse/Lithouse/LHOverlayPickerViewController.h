//
//  LHOverlayPickerViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 7/29/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHOverlayViewController.h"

typedef void (^LHDidSelectRowCallback) (NSInteger selectedRow);

@interface LHOverlayPickerViewController : LHOverlayViewController

- (void) setupOverlayPickerViewWithDataSource:(NSArray *) dataSource
                            withSelectedIndex:(int) selectedIndex
                                    withTitle:(NSString *) title
                     withDidSelectRowCallback:(LHDidSelectRowCallback) didSelectRowCallback;

@end
