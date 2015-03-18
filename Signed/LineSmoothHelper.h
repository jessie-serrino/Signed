//
//  VelocityHelper.h
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/17/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FountainPen,
    FeltTipPen,
    BoringPen,
} PenType;

@interface LineSmoothHelper : NSObject


+ (BOOL) shouldIncludePoint: (CGPoint) newPoint afterPoint: (CGPoint) oldPoint;
- (CGFloat) lineWidthWithVelocity: (CGPoint) velocity andStyle: (PenType) penType;

@end
