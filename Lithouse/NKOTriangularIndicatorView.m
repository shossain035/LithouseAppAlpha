//
//  NKOTriangularIndicatorView.m
//  NKOColorPickerView-Example-iOS
//
//  Created by Shah Hossain on 6/11/14.
//  Copyright (c) 2014 nakioStudio. All rights reserved.
//

#import "NKOTriangularIndicatorView.h"

@implementation NKOTriangularIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint   (ctx, CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, [self.tintColor CGColor]);
    CGContextFillPath(ctx);
}


@end
