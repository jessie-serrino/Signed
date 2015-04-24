//
//  MasterViewController.h
//  Signed
//
//  Created by Jessie Serrino on 4/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController

@property (nonatomic) UIInterfaceOrientation orientation;

- (void) rotateToOrientation;
- (BOOL) shouldAutorotate;

@end
