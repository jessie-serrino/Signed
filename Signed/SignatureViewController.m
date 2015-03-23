//
//  SignatureViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/19/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "SignatureViewController.h"
#import "AddSignatureViewController.h"

static NSString * const SegueToAddSignature = @"SegueToAddSignature";

@interface SignatureViewController ()

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)acceptSignature:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:SegueToAddSignature sender:self];
}
- (IBAction)cancelSignature:(UIBarButtonItem *)sender {

    
    //[self dismissViewControllerAnimated:YES completion:nil];
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation



@end
