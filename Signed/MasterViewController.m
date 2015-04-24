//
//  MasterViewController.m
//  Signed
//
//  Created by Jessie Serrino on 4/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self rotateToOrientation];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self rotateToOrientation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) rotateToOrientation
{
    NSNumber *orientationNumber = [NSNumber numberWithInteger:self.orientation];
    [[UIDevice currentDevice] setValue:orientationNumber forKey:@"orientation"];
}

- (BOOL) shouldAutorotate
{
    return ([[UIApplication sharedApplication] statusBarOrientation] != self.orientation);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
