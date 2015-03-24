//
//  DetailViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/18/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "DetailViewController.h"
#import "DocumentManager.h"
#import "Document.h"

static NSString * const SegueToSignatureView = @"SegueToSignatureView";

@interface DetailViewController ()

@property (nonatomic, strong) Document *document;
@property (strong, nonatomic) IBOutlet UIImageView *documentImage;
@property (strong, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (strong, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (nonatomic)   NSInteger currentPageNumber;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPageNumber = 1;
}

- (void) viewDidAppear:(BOOL)animated
{
    _document = [DocumentManager sharedManager].currentDocument;
    self.documentImage.image = [self.document pageImageWithPageNumber:self.currentPageNumber];

    [self configureNewImages];
    NSLog(@"%@", self.document.fileName);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftPageButtonPressed:(UIButton *)sender {
    if(self.currentPageNumber > 1)
        self.currentPageNumber--;
    
    [self configureNewImages];
}

- (IBAction)rightPageButtonPressed:(UIButton *)sender {
    if(self.currentPageNumber < self.document.numberOfPages)
        self.currentPageNumber++;

    [self configureNewImages];
}

- (void) configureNewImages
{
    self.documentImage.image = [self.document pageImageWithPageNumber:self.currentPageNumber];
    [self configureButtons];
}


- (void)configureButtons
{
    [self setButtonsEnabled];
    UIImage *leftImage = nil;
    UIImage *rightImage = nil;
    if(self.currentPageNumber-1 > 1)
        leftImage =     [self.document thumbnailImageWithPageNumber:(self.currentPageNumber - 1)];
    if(self.currentPageNumber + 1 <= self.document.numberOfPages)
        rightImage = [self.document thumbnailImageWithPageNumber:(self.currentPageNumber + 1)];
    
    [self.leftArrowButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [self.rightArrowButton setBackgroundImage:rightImage forState:UIControlStateNormal];
}

- (void)setButtonsEnabled
{
    [self.leftArrowButton setEnabled:(self.currentPageNumber > 1)];
    [self.rightArrowButton setEnabled:(self.currentPageNumber < self.document.numberOfPages)];
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

- (IBAction) signatureCancelled: (UIStoryboardSegue *) segue
{
    NSLog(@"Cancelling...");
}

-(IBAction)signatureSaved:(UIStoryboardSegue *)segue {
    
    NSLog(@"Saving...");
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
