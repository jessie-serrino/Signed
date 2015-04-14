//
//  VelocityHelper.m
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/17/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "LineSmoothHelper.h"

static NSUInteger const MinimumQuadraticDistance = 5.0f;
static NSUInteger const MaximumLineWidth = 9.0f;
static NSUInteger const MaximumLineWidthFountain = 7.0f;
static NSUInteger const MinimumLineWidth = 2.0f;
static NSUInteger const StandardLineWidth = 5.0f;
static CGFloat    const HistoryDivisor   = 100.0f;

@interface LineSmoothHelper ()
//@property (nonatomic) CGFloat speed1;
//@property (nonatomic) CGFloat speed2;
//@property (nonatomic) CGFloat speed3;
//@property (nonatomic) CGFloat speed4;
//@property (nonatomic) CGFloat speed5;

@property (nonatomic) NSMutableArray *speedArray;


@end

@implementation LineSmoothHelper

- (instancetype)init
{
    self = [super init];
    _speedArray = [[NSMutableArray alloc] initWithObjects:@(0.0f), @(0.0f), @(0.0f), @(0.0f), @(0.0f), nil];

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
    return sqrtf(velocity.x * velocity.x + velocity.y * velocity.y);
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
    if(width > MaximumLineWidthFountain)
        return MaximumLineWidthFountain;
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
    CGFloat speedAverage = newSpeed;
    
    for(NSNumber *num in self.speedArray) {
        speedAverage += [num floatValue];
    }
    
    speedAverage /= (self.speedArray.count + 1);
    [self.speedArray insertObject:@(newSpeed) atIndex:0];
    [self.speedArray removeLastObject];
    
    return speedAverage;
}

@end
