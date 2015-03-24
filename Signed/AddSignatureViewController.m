//
//  AddSignatureViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "AddSignatureViewController.h"
#import "SignatureProcessManager.h"


@interface AddSignatureViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *pageImageView;
@property (strong, nonatomic) Signature *signature;
@property (strong, nonatomic) IBOutlet UIImageView *signatureImageView;
@end

@implementation AddSignatureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    SignatureProcessManager *signatureProcessManager = [SignatureProcessManager sharedManager];
    
    [signatureProcessManager establishSignature];

    _signature = signatureProcessManager.signature;
    
    self.pageImageView.image = [SignatureProcessManager sharedManager].pageImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)tapToAddSignature:(UITapGestureRecognizer *)sender {
    CGPoint touch = [sender locationInView:self.pageImageView];
    
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    CGFloat scale = sender.value;
}




@end
