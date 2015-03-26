//
//  Writing.h
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/16/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "LineSmoothHelper.h"


@interface Line : NSObject

- (instancetype) initWithStartingPoint: (CGPoint) point andPenPreference: (PenType) penPreference andColor: (UIColor *) color;
- (CAShapeLayer *) addConnectedPoint: (CGPoint) point withVelocity: (CGPoint) velocity;
- (CAShapeLayer *) endLineAtPoint: (CGPoint) point withVelocity: (CGPoint) velocity;
- (CAShapeLayer *) lineLayer;
- (void) undoLine;

@end
