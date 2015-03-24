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

- (instancetype) initWithFrame: (CGRect) frame;
- (UIImage *) image;
- (void) undoLine;
- (void) startLineWithPoint: (CGPoint) point;
- (void) continueLineWithPoint: (CGPoint) point andVelocity: (CGPoint) velocity;
- (void) endLineWithPoint: (CGPoint) point andVelocity: (CGPoint) velocity;

@end
