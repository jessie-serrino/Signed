//
//  VelocityHelper.m
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/17/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "LineSmoothHelper.h"

static NSUInteger const MinimumQuadraticDistance = 5.0f;
static NSUInteger const MaximumLineWidth = 8.0f;
static NSUInteger const MinimumLineWidth = 2.0f;
static NSUInteger const StandardLineWidth = 5.0f;
static CGFloat    const HistoryDivisor   = 100.0f;

@interface LineSmoothHelper ()
@property (nonatomic) CGFloat speed1;
@property (nonatomic) CGFloat speed2;
@property (nonatomic) CGFloat speed3;
@property (nonatomic) CGFloat speed4;
@property (nonatomic) CGFloat speed5;




@end

@implementation LineSmoothHelper

- (instancetype)init
{
    self = [super init];

    return self;
}

+ (BOOL) shouldIncludePoint: (CGPoint) newPoint afterPoint: (CGPoint) oldPoint
{
    CGFloat xDistance = newPoint.x - oldPoint.x;
    CGFloat yDistance = newPoint.y - oldPoint.y;
    
    CGFloat distance = sqrtf( powf(xDistance, 2) + powf(yDistance, 2));
    return (distance > MinimumQuadraticDistance);
}

- (CGFloat) speedWithVelocity: (CGPoint) velocity
{
    return sqrtf(velocity.x * velocity.x + velocity.y + velocity.y);
}

- (CGFloat) lineWidthWithVelocity: (CGPoint) velocity andStyle: (PenType) penType
{
    if(penType == BoringPen)
        return StandardLineWidth;
  
    CGFloat historyAverage = [self speedHistoryAverage:velocity];
    if(penType == FountainPen)
        return [self fountainPenWidth:historyAverage];
    return [self feltTipWidth:historyAverage];
}

- (CGFloat) fountainPenWidth: (CGFloat) historyAverage
{
    CGFloat width = historyAverage / HistoryDivisor;
    NSLog(@"width %f", width);
    if(width > MaximumLineWidth)
        return MaximumLineWidth;
    if(width > MinimumLineWidth)
        return width;
    return MinimumLineWidth;
}

- (CGFloat) feltTipWidth: (CGFloat) historyAverage
{
    CGFloat antiWidth = historyAverage / HistoryDivisor;
    CGFloat width = MaximumLineWidth - antiWidth;
    if(width > MinimumLineWidth)
        return width;
    else
        return MinimumLineWidth;

}

- (CGFloat) speedHistoryAverage: (CGPoint) velocity
{
    CGFloat newSpeed = [self speedWithVelocity:velocity];
    CGFloat speedAverage = (self.speed1 + self.speed2 + self.speed3 + newSpeed)/4;
    
    self.speed5 = self.speed4;
    self.speed4 = self.speed3;
    self.speed3 = self.speed2;
    self.speed2 = self.speed1;
    self.speed1 = newSpeed;
    
    return speedAverage;
}

@end
