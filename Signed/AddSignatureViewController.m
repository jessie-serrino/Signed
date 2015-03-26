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
@property (strong, nonatomic) UIImageView *signatureImageView;
@property (strong, nonatomic) IBOutlet UILabel *footerLabel;
@end

@implementation AddSignatureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SignatureProcessManager *signatureProcessManager = [SignatureProcessManager sharedManager];
    
    [signatureProcessManager establishSignature];

    _signature = signatureProcessManager.signature;
    

    
    [self configureFooter];

}

- (void) viewDidAppear:(BOOL)animated
{
    SignatureProcessManager *spm = [SignatureProcessManager sharedManager];
    spm.pdfWriter.pageImageView = self.pageImageView;

    self.pageImageView.image = spm.pageImage;
    UIImage *signatureImage = self.signature.image;
    self.signatureImageView = [[UIImageView alloc] initWithImage:signatureImage];
    
    self.signatureImageView.center = self.pageImageView.center;
    
    // Not fixed
    spm.pdfWriter.touchOnPage = self.signatureImageView.center;
    
    [self.pageImageView addSubview:self.signatureImageView];
    
    CGFloat scale = 0.3;
    
    self.signatureImageView.transform =  CGAffineTransformMakeScale(scale   ,  scale    );
    [SignatureProcessManager sharedManager].pdfWriter.scale = scale;


}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void) scaleImageView: (CGFloat) scale
{
    self.signature.scale = scale;
    CGSize size = self.signatureImageView.frame.size;
    [self.signatureImageView sizeThatFits:CGSizeMake(size.width, size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureFooter
{
    self.footerLabel.text = [NSString stringWithFormat:@"%li of %li", self.signature.page, [SignatureProcessManager sharedManager].document.numberOfPages];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)tapToAddSignature:(UIPanGestureRecognizer *)sender {
    SignatureProcessManager *spm = [SignatureProcessManager sharedManager];
    
    spm.pdfWriter.touchOnPage = [sender locationInView:self.pageImageView];
    spm.pdfWriter.signatureImageView = self.signatureImageView;
    
    self.signatureImageView.center = spm.pdfWriter.touchOnPage;
    
}


- (IBAction)sliderValueChanged:(UISlider *)sender {
    CGFloat scale = sender.value;
    
    self.signatureImageView.transform =  CGAffineTransformMakeScale(scale, scale);
    [SignatureProcessManager sharedManager].pdfWriter.scale = scale;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[SignatureProcessManager sharedManager] sealSignature];
}



@end
