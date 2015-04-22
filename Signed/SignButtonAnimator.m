//
//  SignButtonAnimator.m
//  Signed
//
//  Created by Jessie Serrino on 4/15/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "SignButtonAnimator.h"
#import "POPSpringAnimation.h"

static NSString * const SignButtonUpAnimation = @"SignButtonUpAnimation";
static NSInteger const SpringBounciness = 10.0;

@implementation SignButtonAnimator

+ (void) animateSignButton: (NSLayoutConstraint *) constraint appearing: (BOOL) isAppearing
{
    [constraint pop_removeAllAnimations];
    
    
    POPSpringAnimation *moveVertical = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    if(isAppearing)
    {
        moveVertical.fromValue = @(200);
        moveVertical.toValue = @(0);
    }
    else
    {
        moveVertical.fromValue = @(0);
        moveVertical.toValue = @(200);
    }
    moveVertical.springBounciness = SpringBounciness;
    
    [constraint pop_addAnimation:moveVertical forKey:SignButtonUpAnimation];
}

@end

