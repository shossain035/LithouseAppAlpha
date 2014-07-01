//
//  LHCollectionViewCell.h
//  Lithouse
//
//  Created by Shah Hossain on 6/30/14.
//  Copyright (c) 2014 Shah Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LHCollectionViewCellInfoButtonCallbackBlock) (void);
typedef void (^LHCollectionViewCellToggleCallbackBlock)     (void);

@interface LHCollectionViewCell : UICollectionViewCell

@property (copy) LHCollectionViewCellInfoButtonCallbackBlock   infoButtonCallback;
@property (copy) LHCollectionViewCellToggleCallbackBlock       toggleCallbackBlock;

- (void) toggle;
- (void) activate : (BOOL) isActive;

@end
