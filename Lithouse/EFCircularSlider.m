//
//  EFCircularSlider.m
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "EFCircularSlider.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

static const float kLowerAngle = 205.0;
static const float kUpperAngle = 335.0;
static const float kNobDiameter = 10.0;

#define kDefaultFontSize 14.0f;
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@interface EFCircularSlider ()

@property (nonatomic, strong, readonly) UILabel* currentValueLabel;

@end

@interface EFCircularSlider (private)

@property (readonly, nonatomic) CGFloat radius;

@end

@implementation EFCircularSlider {
    int angle;
    //int fixedAngle;
    NSMutableDictionary* labelsWithPercents;
    NSArray* labelsEvenSpacing;
}

@synthesize currentValueLabel = _currentValueLabel;

- (void)defaults {
    // Defaults
    _maximumValue = 100.0f;
    _minimumValue = 60.0f;
    _currentValue = 72.0f;
    _lineWidth = 5;
    _lineRadiusDisplacement = 0;
    _unfilledColor = [UIColor lightGrayColor];
    _filledColor = [UIColor redColor];
    _handleColor = _filledColor;
    _labelFont = [UIFont systemFontOfSize:10.0f];
    _snapToLabels = NO;
    _handleType = EFSemiTransparentWhiteCircle;
    _labelColor = [UIColor redColor];
    _labelDisplacement = 2;
    
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaults];
        
        [self setFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self=[super initWithCoder:aDecoder])){
        [self defaults];
    }
    
    return self;
}


#pragma mark - Setter/Getter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    angle = [self angleFromValue];
}

- (CGFloat)radius {
    //radius = self.frame.size.height/2 - [self circleDiameter]/2;
    return self.frame.size.height/2 - _lineWidth/2 - ([self circleDiameter]-_lineWidth) - _lineRadiusDisplacement;
}

- (void)setCurrentValue:(float)currentValue {
    _currentValue=currentValue;
    
    if(_currentValue>_maximumValue) _currentValue=_maximumValue;
    else if(_currentValue<_minimumValue) _currentValue=_minimumValue;
    
    angle = [self angleFromValue];
    [self setNeedsLayout];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - drawing methods

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithArcCenter : CGPointMake(150, 150)
//                                                               radius : self.frame.size.width/2
//                                                           startAngle : M_PI*2.0/3.0
//                                                             endAngle : M_PI * 7.0/3.0
//                                                            clockwise : NO];
//    outlinePath.lineCapStyle = kCGLineCapRound;
//    CGContextAddPath(ctx, outlinePath.CGPath);
//    CGContextClip(ctx);
//    outlinePath.lineWidth = _lineWidth;
//    
//    CGContextSetFillColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
//    CGContextAddPath(ctx, outlinePath.CGPath);
//    CGContextFillPath(ctx);
    
    //Draw the unfilled circle
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, self.radius, M_PI*2.0/3.0, M_PI * 7.0/3.0, 0);
    [_unfilledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //Draw the filled circle
//    if((_handleType == EFDoubleCircleWithClosedCenter || _handleType == EFDoubleCircleWithOpenCenter) && fixedAngle > 5) {
//        CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, self.radius, 3*M_PI/2, 3*M_PI/2-ToRad(angle+3), 0);
//    } else {
        CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, self.radius, M_PI*2.0/3.0, ToRad(angle), 0);
//    }
    [_filledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Add the labels (if necessary)
    if(labelsEvenSpacing != nil) {
        [self drawLabels:ctx];
    }
    
    //The draggable part
    [self drawHandle:ctx];
}


-(void) drawHandle:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    /*
    CGPoint handleCenter =  [self pointFromAngle: angle];
    if(_handleType == EFSemiTransparentWhiteCircle) {
        [[UIColor colorWithWhite:1.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth, _lineWidth));
    } else if(_handleType == EFSemiTransparentBlackCircle) {
        [[UIColor colorWithWhite:0.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth, _lineWidth));
    } else if(_handleType == EFDoubleCircleWithClosedCenter) {
        [_handleColor set];
        CGContextAddArc(ctx, handleCenter.x + (_lineWidth)/2, handleCenter.y + (_lineWidth)/2, _lineWidth, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 7);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth-1, _lineWidth-1));
    } else if(_handleType == EFDoubleCircleWithOpenCenter) {
        [_handleColor set];
        CGContextAddArc(ctx, handleCenter.x + (_lineWidth)/2, handleCenter.y + (_lineWidth)/2, _lineWidth/2 + 5, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 4);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextAddArc(ctx, handleCenter.x + _lineWidth/2, handleCenter.y + _lineWidth/2, _lineWidth/2, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
    } else if(_handleType == EFBigCircle) {
        [_handleColor set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-2.5, handleCenter.y-2.5, _lineWidth+5, _lineWidth+5));
    }
    */
    
    self.currentValueLabel.text = [NSString stringWithFormat:@"%.0f", _currentValue];
    CGPoint valueLabelCenter =  [self pointFromAngle:angle withRadius:self.radius+30];
    self.currentValueLabel.frame = CGRectMake(valueLabelCenter.x, valueLabelCenter.y, 60, 30);
    
    CGPoint handleCenter =  [self pointFromAngle: angle];
    CGRect knobFrame = CGRectMake(handleCenter.x-kNobDiameter/2.0, handleCenter.y-kNobDiameter/2.0, _lineWidth+kNobDiameter, _lineWidth+kNobDiameter);
    
    UIBezierPath *knobPath = [UIBezierPath bezierPathWithRoundedRect:knobFrame
                                                        cornerRadius:knobFrame.size.height * 0.5];
    
    // 1) fill - with a subtle shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor );
    CGContextAddPath(ctx, knobPath.CGPath);
    CGContextFillPath(ctx);
    
    // 2) outline
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextAddPath(ctx, knobPath.CGPath);
    CGContextStrokePath(ctx);
    
    
    // 3) inner gradient
    CGRect rect = CGRectInset(knobFrame, 2.0, 2.0);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        cornerRadius:rect.size.height * 0.5];
    
    CGGradientRef myGradient;
    CGColorSpaceRef myColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 0.0, 0.0 , 0.15,  // Start color
        0.0, 0.0, 0.0, 0.05 }; // End color
    
    myColorspace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
                                                      locations, num_locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, clipPath	.CGPath);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, myGradient, startPoint, endPoint, 0);
    
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorspace);
    CGContextRestoreGState(ctx);
    
    // 4) highlight
//    if (self.highlighted)
//    {
//        // fill
//        CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0.0 alpha:0.1].CGColor);
//        CGContextAddPath(ctx, knobPath.CGPath);
//        CGContextFillPath(ctx);
//    }

    CGContextRestoreGState(ctx);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint p1 = [self centerPoint];
    CGPoint p2 = point;
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    double distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance < self.radius + 11;
}

-(void) drawLabels:(CGContextRef)ctx {
//    if(labelsEvenSpacing == nil || [labelsEvenSpacing count] == 0) {
//        return;
//    } else {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
//        NSDictionary *attributes = @{ NSFontAttributeName: _labelFont,
//                                      NSForegroundColorAttributeName: _labelColor
//                                      };
//#endif
//        
//        CGFloat fontSize = ceilf(_labelFont.pointSize);
//        
//        NSInteger distanceToMove = -[self circleDiameter]/2 - fontSize/2 - _labelDisplacement;
//        
//        for (int i=0; i<[labelsEvenSpacing count]; i++)
//        {
//            NSString *label = [labelsEvenSpacing objectAtIndex:[labelsEvenSpacing count] - i - 1];
//            CGFloat percentageAlongCircle = i/(float)[labelsEvenSpacing count];
//            CGFloat degreesForLabel = percentageAlongCircle * 360;
//            
//            CGSize labelSize=CGSizeMake([self widthOfString:label withFont:_labelFont], [self heightOfString:label withFont:_labelFont]);
//            CGPoint closestPointOnCircleToLabel = [self pointFromAngle:degreesForLabel withObjectSize:labelSize];
//
//            CGRect labelLocation = CGRectMake(closestPointOnCircleToLabel.x, closestPointOnCircleToLabel.y, labelSize.width, labelSize.height);
//            
//            CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//            float radiansTowardsCenter = ToRad(AngleFromNorth(centerPoint, closestPointOnCircleToLabel, NO));
//            
//            labelLocation.origin.x = (labelLocation.origin.x + distanceToMove * cos(radiansTowardsCenter));
//            labelLocation.origin.y = (labelLocation.origin.y + distanceToMove * sin(radiansTowardsCenter));
//            
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
//            [label drawInRect:labelLocation withAttributes:attributes];
//#else
//            [_labelColor setFill];
//            [label drawInRect:labelLocation withFont:_labelFont];
//#endif
//        }
//    }
}

#pragma mark - UIControl functions

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    return YES;
}

-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    /*
    if(_snapToLabels && labelsEvenSpacing != nil) {
        CGFloat newAngle=0;
        float minDist = 360;
        for (int i=0; i<[labelsEvenSpacing count]; i++) {
            CGFloat percentageAlongCircle = i/(float)[labelsEvenSpacing count];
            CGFloat degreesForLabel = percentageAlongCircle * 360;
            if(abs(fixedAngle - degreesForLabel) < minDist) {
                newAngle=degreesForLabel ? 360 - degreesForLabel : 0;
                minDist = abs(fixedAngle - degreesForLabel);
            }
        }
        angle = newAngle;
        _currentValue = [self valueFromAngle];
        [self setNeedsDisplay];
    }
     */
}

-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint;
    centerPoint = [self centerPoint];
    angle = floor(AngleFromNorth(centerPoint, point, NO));
    
    if (angle < kLowerAngle) angle = kLowerAngle;
    else if ( angle > kUpperAngle ) angle = kUpperAngle;
    
    _currentValue = [self valueFromAngle];
    [self setNeedsDisplay];
}

- (CGPoint)centerPoint {
    return CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

#pragma mark - helper functions

-(CGPoint)pointFromAngle:(int)angleInt
              withRadius:(CGFloat)radius{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2, self.frame.size.height/2 - _lineWidth/2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(angleInt)));
    
    return result;
}

-(CGPoint)pointFromAngle:(int)angleInt{
    
        return [self pointFromAngle:angleInt withRadius:self.radius];
}

//-(CGPoint)pointFromAngle:(int)angleInt withObjectSize:(CGSize)size{
//    
//    //Define the Circle center
//    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - size.width/2, self.frame.size.height/2 - size.height/2);
//    
//    //Define The point position on the circumference
//    CGPoint result;
//    result.y = round(centerPoint.y + self.radius * sin(ToRad(-angleInt-90))) ;
//    result.x = round(centerPoint.x + self.radius * cos(ToRad(-angleInt-90)));
//    
//    return result;
//}

- (CGFloat)circleDiameter {
    if(_handleType == EFSemiTransparentWhiteCircle) {
        return _lineWidth;
    } else if(_handleType == EFSemiTransparentBlackCircle) {
        return _lineWidth;
    } else if(_handleType == EFDoubleCircleWithClosedCenter) {
        return _lineWidth * 2 + 3.5;
    } else if(_handleType == EFDoubleCircleWithOpenCenter) {
        return _lineWidth + 2.5 + 2;
    } else if(_handleType == EFBigCircle) {
        return _lineWidth + kNobDiameter/2;
    }
    return 0;
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float result = ToDeg(atan2(v.y,v.x));
    result = (result >=0  ? result : result + 360.0);
    
    //discarding 1st quardent
    if ( result < 90 ) result = 360.0;

    return result;
}

-(float) valueFromAngle {
    if (_currentValue < _minimumValue) _currentValue = _minimumValue;
    else if (_currentValue > _maximumValue) _currentValue = _maximumValue;
    /*
    if(angle < 0) {
        _currentValue = -angle;
    } else {
        _currentValue = 270 - angle + 90;
    }
    fixedAngle = _currentValue;
    
    return (_currentValue*(_maximumValue - _minimumValue))/360.0f;
     */
    //fixedAngle = angle;
    return ((angle - kLowerAngle) / (kUpperAngle-kLowerAngle)) * (_maximumValue-_minimumValue) + _minimumValue;
}

-(UILabel *) currentValueLabel {
    if ( _currentValueLabel ) {
        return _currentValueLabel;
    }
    _currentValueLabel = [[UILabel alloc] init];
    _currentValueLabel.backgroundColor = [UIColor clearColor];
    _currentValueLabel.userInteractionEnabled = NO;
    _currentValueLabel.textColor = [UIColor blackColor];
    //_currentValueLabel.font = [_currentValueLabel.font fontWithSize:20];
    [self addSubview:_currentValueLabel];
    
    return _currentValueLabel;
}

- (float)angleFromValue {
    angle = kLowerAngle + (kUpperAngle-kLowerAngle) * (_currentValue-_minimumValue)/(_maximumValue-_minimumValue);
    
    if (angle < kLowerAngle) angle = kLowerAngle;
    else if ( angle > kUpperAngle ) angle = kUpperAngle;
    
    return angle;
}

- (CGFloat) widthOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (CGFloat) heightOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height;
}

#pragma mark - public methods
-(void)setInnerMarkingLabels:(NSArray*)labels{
    labelsEvenSpacing = labels;
    [self setNeedsDisplay];
}

@end
