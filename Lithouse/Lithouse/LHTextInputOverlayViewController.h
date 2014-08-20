//
//  LHTextInputOverlayViewController.h
//  Lithouse
//
//  Created by Shah Hossain on 8/19/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import "LHOverlayViewController.h"

@protocol LHTextInputOverlayViewControllerDelegate <NSObject>
- (NSString *) placeholder;
- (void) processInput:(NSString *) inputText
     withMessageLabel:(UILabel *) messageLabel;

@end

@interface LHTextInputOverlayViewController : LHOverlayViewController

@property (nonatomic, strong) id<LHTextInputOverlayViewControllerDelegate> delegate;

//todo: move to common base
+ (void) showMessage:(NSString *) messageText toLabel:(UILabel *) targetLabel isError:(BOOL) isError;
@end


