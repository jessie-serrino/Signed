//
//  SignatureViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/19/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "SignatureViewController.h"
#import "AddSignatureViewController.h"
#import "SignatureProcessManager.h"

static NSString * const SegueToAddSignature = @"SegueToAddSignature";

@interface SignatureViewController ()
@property (strong, nonatomic) IBOutlet UIView *drawableView;
@property (strong, nonatomic) SignatureMaker *signatureMaker;
@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self initializeSignatureMaker];
}

- (void) initializeSignatureMaker
{
    if([SignatureProcessManager sharedManager].signatureMaker){
        self.signatureMaker = [SignatureProcessManager sharedManager].signatureMaker;
        [self.signatureMaker addLinesToView: self.drawableView];
    }
    else{
            self.signatureMaker = [[SignatureMaker alloc] initWithFrame:self.drawableView.bounds];
        [SignatureProcessManager sharedManager].signatureMaker = self.signatureMaker;
    }
    [self.drawableView.layer addSublayer:self.signatureMaker];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)drawSignatureMotion:(UIPanGestureRecognizer *)sender {
    CGPoint touch = [sender locationInView:self.drawableView];
    CGPoint velocity = [sender velocityInView:self.drawableView];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        [self.signatureMaker startLineWithPoint:touch];
    } else if(sender.state == UIGestureRecognizerStateChanged){
        [self.signatureMaker continueLineWithPoint:touch andVelocity:velocity];
    } else if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        [self.signatureMaker endLineWithPoint:touch andVelocity:velocity];
    }
}


- (IBAction)acceptSignature:(UIBarButtonItem *)sender {
    
    
    [self performSegueWithIdentifier:SegueToAddSignature sender:self];
}
- (IBAction)cancelSignature:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)penPreferenceButtonTouched:(UIButton *)sender {
    
    if([sender.currentTitle isEqualToString:@"Felt Tip"])
        self.signatureMaker.penPreference = FeltTipPen;
    else
        self.signatureMaker.penPreference = FountainPen;
}




- (IBAction)blackColorButtonTouched:(id)sender {
    self.signatureMaker.penColor = [UIColor blackColor];
}

- (IBAction)blueColorButtonTouched:(id)sender {
    self.signatureMaker.penColor = [UIColor blueColor];
}

- (IBAction)redColorButtonTouched:(id)sender {
    self.signatureMaker.penColor = [UIColor redColor];
}

- (IBAction)undoButton:(UIButton *)sender {
    [self.signatureMaker undoLine];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Create signature image");
}



@end
