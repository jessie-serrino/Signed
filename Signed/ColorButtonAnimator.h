//
//  ColorButtonAnimator.h
//  Signed
//
//  Created by Jessie Serrino on 3/29/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "POPSpringAnimation.h"
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BlackColor,
    BlueColor,
    RedColor,
} ColorType;

@interface ColorButtonAnimator : NSObject

+ (void) animateColorButton: (NSLayoutConstraint *) constraint withColor: (ColorType) colorType opening: (BOOL) isOpening;

@end
