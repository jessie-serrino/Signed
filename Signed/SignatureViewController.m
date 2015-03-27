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
#import <pop/POP.h>

static NSString * const SegueToAddSignature = @"SegueToAddSignature";
static NSInteger const FirstButtonDistance = 150;
static NSInteger const SecondButtonDistance = 100;
static NSInteger const ThirdButtonDistance = 50;
static NSInteger const SpringBounciness = 20.0;



@interface SignatureViewController ()
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIView *drawableView;
@property (strong, nonatomic) IBOutlet UIButton *colorButton;
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
    // Do any additional setup after loading the view.
    self.colorMenuOpen = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self initializeSignatureMaker];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self animateOpenColorMenu];
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
    
}
- (IBAction)clearButtonPressed:(id)sender {
    [self.signatureMaker clearAll];
    [self.clearButton pop_removeAllAnimations];
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

- (void) animateOpenColorMenu
{
    [self.colorButton pop_removeAllAnimations];
    POPSpringAnimation *turnButton = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    turnButton.fromValue = 0;
    turnButton.toValue = @(-1.0*M_PI_2);
    turnButton.springBounciness = SpringBounciness;
    [self.colorButton.layer pop_addAnimation:turnButton forKey:@"rotationButtonOpen"];
    
    /* Black button */
    [self.blackCenterXConstraint pop_removeAllAnimations];
    POPSpringAnimation *moveBlackLeft = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    moveBlackLeft.fromValue = 0;
    moveBlackLeft.toValue = @(-FirstButtonDistance);
    moveBlackLeft.springBounciness = SpringBounciness;
    [self.blackCenterXConstraint pop_addAnimation:moveBlackLeft forKey:@"moveBlackLeft"];
    
    
    /* Blue button */
    [self.blueCenterXConstraint pop_removeAllAnimations];
    POPSpringAnimation *moveBlueLeft = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    moveBlueLeft.fromValue = 0;
    moveBlueLeft.toValue = @(SecondButtonDistance);
    moveBlueLeft.springBounciness = SpringBounciness;
    
    [self.blueCenterXConstraint pop_addAnimation:moveBlueLeft forKey:@"moveBlueLeft"];
    
    [self.blueCenterYConstraint pop_removeAllAnimations];
    
    
    /* Red button */
    
    [self.redCenterXConstraint pop_removeAllAnimations];
    POPSpringAnimation *moveRedLeft = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    moveRedLeft.fromValue = 0;
    moveRedLeft.toValue = @(-ThirdButtonDistance);
    moveRedLeft.springBounciness =SpringBounciness;
    [self.redCenterXConstraint pop_addAnimation:moveRedLeft forKey:@"moveRedLeft"];

    self.colorMenuOpen = YES;


}



- (void) animateCloseColorMenu
{
    [self.colorButton pop_removeAllAnimations];
    POPSpringAnimation *turnButton = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    turnButton.fromValue = @(M_PI_2 + M_PI);
    turnButton.toValue = @(2*M_PI);
    [self.colorButton.layer pop_addAnimation:turnButton forKey:@"rotationButtonClosed"];
    
    
    /* Black button */
    [self.blackButton    pop_removeAllAnimations];
    
    [self.blackCenterXConstraint pop_removeAllAnimations];
    POPSpringAnimation *moveBlackRight = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    moveBlackRight.fromValue = @(-FirstButtonDistance);
    moveBlackRight.toValue = @(0);
    [self.blackCenterXConstraint pop_addAnimation:moveBlackRight forKey:@"moveBlackRight"];
    
    
    
    /* Blue button */
    [self.blueCenterXConstraint pop_removeAllAnimations];
    POPSpringAnimation *moveBlueRight = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    moveBlueRight.fromValue = @(SecondButtonDistance);
    moveBlueRight.toValue = @(0);
    [self.blueCenterXConstraint pop_addAnimation:moveBlueRight forKey:@"moveBlueRight"];
    
    
    
    /* Red button */
    
    [self.redCenterXConstraint pop_removeAllAnimations];
    POPSpringAnimation *moveRedRight = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    moveRedRight.fromValue = @(-ThirdButtonDistance);
    moveRedRight.toValue = @(0);
    [self.redCenterXConstraint pop_addAnimation:moveRedRight forKey:@"moveRedRight"];
    
    
    
    self.colorMenuOpen = NO;
}



@end
