//
//  LHModalPickerViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 5/14/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSInteger (^LHNumberOfRowsCallback)            (void);
typedef void      (^LHUpdateCellAtIndexPathCallback)   (UITableViewCell * cell, NSIndexPath * indexPath);
typedef void      (^LHDidSelectRowAtIndexPathCallback) (NSIndexPath * indexPath);

@interface LHModalPickerViewController : UITableViewController

@property (copy) LHNumberOfRowsCallback            numberOfRowsCallback;
@property (copy) LHUpdateCellAtIndexPathCallback   updateCellAtIndexPathCallback;
@property (copy) LHDidSelectRowAtIndexPathCallback didSelectRowAtIndexPathCallback;

@end
