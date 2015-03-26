//
//  Signature.h
//  SignatureLibrary
//
//  Created by Jessie Serrino on 3/17/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Line.h"


@interface SignatureMaker : CALayer


@property (nonatomic)   PenType penPreference;
@property (nonatomic, strong) UIColor *penColor;

- (instancetype) initWithFrame: (CGRect) frame;
- (UIImage *) image;

- (void) undoLine;
- (void) logBounds;
- (void) startLineWithPoint: (CGPoint) point;
- (void) continueLineWithPoint: (CGPoint) point andVelocity: (CGPoint) velocity;
- (void) endLineWithPoint: (CGPoint) point andVelocity: (CGPoint) velocity;

@end
