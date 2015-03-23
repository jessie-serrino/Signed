//
//  DetailViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/18/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "DetailViewController.h"

static NSString * const SegueToSignatureView = @"SegueToSignatureView";

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(UIButton *)sender {
}
- (IBAction)sendButtonPressed:(UIButton *)sender {
}
- (IBAction)signButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:SegueToSignatureView sender:self];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}



-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {

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
