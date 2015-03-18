//
//  UIBezierPath+Subline.m
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/17/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "UIBezierPath+Subline.h"

@implementation UIBezierPath (Subline)

+ (Subline *) subline
{
    return [UIBezierPath bezierPath];
}

+ (Subline *) lineToMidpointFromStart: (CGPoint) start end: (CGPoint) end
{
    Subline *subline = [Subline subline];
    CGPoint midPoint = CGPointMake((start.x + end.x)/2, (start.y + end.y)/2);
    
    [subline moveToPoint:start];
    [subline addLineToPoint:midPoint];
    [subline closePath];
    
    return subline;
}

+ (Subline *) curveFromMidpoint: (CGPoint) startMidpoint toMidpoint: (CGPoint) endMidpoint withControl: (CGPoint) controlPoint
{
    Subline *subline = [Subline subline];
    [subline moveToPoint:startMidpoint];
    [subline addQuadCurveToPoint:endMidpoint controlPoint:controlPoint];
    [subline closePath];
    return subline;
}

+ (Subline *) sublineCurveToMidpointFromStart: (CGPoint) start toEnd: (CGPoint) end
{
    Subline *subline = [Subline subline];

    return subline;
}

@end
