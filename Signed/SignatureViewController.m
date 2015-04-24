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
#import "ColorButtonAnimator.h"

static NSString * const SegueToAddSignature = @"SegueToAddSignature";
static NSInteger const SpringBounciness = 20.0;



@interface SignatureViewController ()
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIView *drawableView;
@property (strong, nonatomic) IBOutlet UIButton *colorButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *undoButton;
@property (nonatomic)                  BOOL     colorMenuOpen;
@property (strong, nonatomic) SignatureMaker *signatureMaker;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *redCenterXConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *redCenterYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blackCenterXConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blackCenterYConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blueCenterXConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blueCenterYConstraint;
@property (strong, nonatomic) IBOutlet UIButton *blackButton;
@property (strong, nonatomic) IBOutlet UIButton *blueButton;
@property (strong, nonatomic) IBOutlet UIButton *redButton;

/* CONSTRAINTS */



@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orientation = UIInterfaceOrientationLandscapeLeft;

    self.colorMenuOpen = NO;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initializeSignatureMaker];
    self.acceptButton.enabled = !self.signatureMaker.blank;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateOpenColorMenu];
}


//- (void) rotateToOrientation: (UIInterfaceOrientation) orientation
//{
//    NSNumber *orientationNumber = [NSNumber numberWithInteger:orientation];
//    [[UIDevice currentDevice] setValue:orientationNumber forKey:@"orientation"];
//}

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
    
    if(self.colorMenuOpen)
        [self animateCloseColorMenu];
    
    self.acceptButton.enabled = !self.signatureMaker.blank;
    
}

- (IBAction)acceptSignature:(UIButton *)sender {
    [self performSegueWithIdentifier:SegueToAddSignature sender:self];

}

- (IBAction)cancelSignature:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)feltTipButtonTouched:(id)sender
{
    self.signatureMaker.penPreference = FeltTipPen;
}

- (IBAction)fountainPenButtonTouched:(id)sender
{
    self.signatureMaker.penPreference = FountainPen;
}


- (IBAction)blackColorButtonTouched:(id)sender {
    self.signatureMaker.penColor = [UIColor blackColor];
    [self animateCloseColorMenu];
}

- (IBAction)blueColorButtonTouched:(id)sender {
    self.signatureMaker.penColor = [UIColor colorWithRed: 0.075 green: 0.349 blue: 0.682 alpha: 1];
    [self animateCloseColorMenu];
}

- (IBAction)redColorButtonTouched:(id)sender {
    self.signatureMaker.penColor = [UIColor colorWithRed: 0.808 green: 0.039 blue: 0.141 alpha: 1];

    [self animateCloseColorMenu];
}

- (IBAction)undoButtonPressed:(UIButton *)sender {
    [self.signatureMaker undoLine];
    [self.undoButton pop_removeAllAnimations];
    POPSpringAnimation *rotateUndo = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotateUndo.fromValue = 0;
    rotateUndo.toValue = @(-2*M_PI);
    [self.undoButton.layer pop_addAnimation:rotateUndo forKey:@"rotateUndo"];
    self.acceptButton.enabled = !self.signatureMaker.blank;

    
}
- (IBAction)clearButtonPressed:(id)sender {
    [self.signatureMaker clearAll];
    [self.clearButton pop_removeAllAnimations];
    self.acceptButton.enabled = NO;
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
- (IBAction)colorButton:(id)sender {
    
    if(!self.colorMenuOpen)
        [self animateOpenColorMenu];
    else
        [self animateCloseColorMenu];
}


/* Animation stuff */
- (void) animateOpenColorMenu
{
    [self.colorButton pop_removeAllAnimations];
    POPSpringAnimation *turnButton = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    turnButton.fromValue = 0;
    turnButton.toValue = @(-1.0*M_PI_2);
    turnButton.springBounciness = SpringBounciness;
    [self.colorButton.layer pop_addAnimation:turnButton forKey:@"rotationButtonOpen"];
    
    [ColorButtonAnimator animateColorButton:self.blackCenterXConstraint withColor:BlackColor opening:YES];
    [ColorButtonAnimator animateColorButton:self.blueCenterXConstraint withColor:BlueColor opening:YES];
    [ColorButtonAnimator animateColorButton:self.redCenterXConstraint withColor:RedColor opening:YES];
    
    self.colorMenuOpen = YES;
}



- (void) animateCloseColorMenu
{
    [self.colorButton pop_removeAllAnimations];
    POPSpringAnimation *turnButton = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    turnButton.fromValue = @(M_PI_2 + M_PI);
    turnButton.toValue = @(2*M_PI);
    [self.colorButton.layer pop_addAnimation:turnButton forKey:@"rotationButtonClosed"];
    
    [ColorButtonAnimator animateColorButton:self.blackCenterXConstraint withColor:BlackColor opening:NO];
    [ColorButtonAnimator animateColorButton:self.blueCenterXConstraint withColor:BlueColor opening:NO];
    [ColorButtonAnimator animateColorButton:self.redCenterXConstraint withColor:RedColor opening:NO];
    
    self.colorMenuOpen = NO;
}




@end
