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


@interface Line : NSObject

- (instancetype) initWithStartingPoint: (CGPoint) point;
- (CAShapeLayer *) addConnectedPoint: (CGPoint) point withVelocity: (CGPoint) velocity;
- (CAShapeLayer *) endLineAtPoint: (CGPoint) point withVelocity: (CGPoint) velocity;
@end
