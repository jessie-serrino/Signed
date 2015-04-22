//
//  SignButtonAnimator.h
//  Signed
//
//  Created by Jessie Serrino on 4/15/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SignButtonAnimator : NSObject

+ (void) animateSignButton: (NSLayoutConstraint *) constraint appearing: (BOOL) isAppearing;


@end
