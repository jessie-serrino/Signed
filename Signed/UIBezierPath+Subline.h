//
//  UIBezierPath+Subline.h
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/17/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIBezierPath Subline;

@interface UIBezierPath (Subline)

+ (Subline *) subline;
+ (Subline *) lineToMidpointFromStart: (CGPoint) start end: (CGPoint) end;
+ (Subline *) curveFromMidpoint: (CGPoint) startMidpoint toMidpoint: (CGPoint) endMidpoint withControl: (CGPoint) controlPoint;
@end
