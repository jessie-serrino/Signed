//
//  ColorButtonAnimator.m
//  Signed
//
//  Created by Jessie Serrino on 3/29/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "ColorButtonAnimator.h"


static NSString * const BlackColorOpenAnimation = @"BlackColorOpenAnimation";
static NSString * const BlackColorCloseAnimation = @"BlackColorCloseAnimation";
static NSInteger const BlackButtonDistance = -150;

static NSString * const BlueColorOpenAnimation = @"BlueColorOpenAnimation";
static NSString * const BlueColorCloseAnimation = @"BlueColorCloseAnimation";
static NSInteger const BlueButtonDistance = 100;


static NSString * const RedColorOpenAnimation = @"RedColorOpenAnimation";
static NSString * const RedColorCloseAnimation = @"RedColorCloseAnimation";
static NSInteger const RedButtonDistance = -50;

static NSInteger const SpringBounciness = 20.0;



@implementation ColorButtonAnimator



+ (void) animateColorButton: (NSLayoutConstraint *) constraint withColor: (ColorType) colorType opening: (BOOL) isOpening
{
    NSString *key;
    CGFloat magnitude;
    switch(colorType)
    {
        case BlackColor:
            key = isOpening? BlackColorOpenAnimation : BlackColorCloseAnimation;
            magnitude = BlackButtonDistance;
            break;
            
        case BlueColor:
            key = isOpening? BlueColorOpenAnimation : BlueColorCloseAnimation;
            magnitude = BlueButtonDistance;
            break;
            
        case RedColor:
            key = isOpening? RedColorOpenAnimation : RedColorCloseAnimation;
            magnitude = RedButtonDistance;
            break;
            
        default:
            NSLog(@"Color Button Animator has been called incorrectly");
            break;
    }
    
    if(isOpening)
        [ColorButtonAnimator animateOpenButton:constraint toValue:magnitude withKey:key];
    else
        [ColorButtonAnimator animateCloseButton:constraint fromValue:magnitude withKey:key];
}

//+ (void) animateButton: (NSLayoutConstraint *) constraint toValue: (

+ (void) animateOpenButton: (NSLayoutConstraint *) constraint toValue: (CGFloat) location withKey: (NSString *) key
{
    [constraint pop_removeAllAnimations];
    
    POPSpringAnimation *moveLeft = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    moveLeft.fromValue = @(0);
    moveLeft.toValue = @(location);
    moveLeft.springBounciness = SpringBounciness;
    
    [constraint pop_addAnimation:moveLeft forKey:key];

}

+ (void) animateCloseButton: (NSLayoutConstraint *) constraint fromValue: (CGFloat) location withKey: (NSString *) key
{
    [constraint pop_removeAllAnimations];
    POPSpringAnimation *moveRight = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    moveRight.fromValue = @(location);
    moveRight.toValue = @(0);
    [constraint pop_addAnimation:moveRight forKey:key];
}



@end
