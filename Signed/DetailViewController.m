//
//  DetailViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/18/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "DetailViewController.h"
#import "SignatureViewController.h"

#import "DocumentManager.h"
#import "Document.h"

static NSString * const SegueToSignatureView = @"SegueToSignatureView";

@interface DetailViewController ()

@property (nonatomic, strong) Document *document;
@property (strong, nonatomic) IBOutlet UIImageView *documentImage;
@property (strong, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (strong, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (nonatomic)   NSInteger currentPageNumber;
@property (strong, nonatomic) IBOutlet UILabel *footerLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPageNumber = 1;
    
    self.documentImage.layer.shadowColor = [UIColor grayColor].CGColor;
    self.documentImage.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.documentImage.layer.shadowRadius = 2.0f;
    self.documentImage.layer.shadowOpacity = 0.3f;
}

- (void) viewDidAppear:(BOOL)animated
{
    _document = [DocumentManager sharedManager].currentDocument;
    self.title = self.document.fileName;
    self.documentImage.image = [self.document pageImageWithPageNumber:self.currentPageNumber];

    [self configureVisuals];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftPageButtonPressed:(UIButton *)sender {
    if(self.currentPageNumber > 1)
        self.currentPageNumber--;
    
    [self configureFooter];
    [self configureNewImages];
}

- (IBAction)rightPageButtonPressed:(UIButton *)sender {
    if(self.currentPageNumber < self.document.numberOfPages)
        self.currentPageNumber++;
    [self configureFooter];
    [self configureNewImages];
}

- (void) configureVisuals
{
    [self configureFooter];
    [self configureNewImages];
}
- (void) configureFooter
{
    self.footerLabel.text = [NSString stringWithFormat:@"%i of %i", self.currentPageNumber, self.document.numberOfPages ];
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
    if(self.currentPageNumber- 1 >= 1)
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



- (IBAction)signButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:SegueToSignatureView sender:self];
}
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (IBAction)sendImage:(id)sender {
    
    NSURL *location = [[DocumentManager sharedManager] saveToTemporaryFolder];
    
    UIActivityViewController *av = [[UIActivityViewController alloc] initWithActivityItems:@[@"", location] applicationActivities:nil];
    
    [self presentViewController:av animated:YES completion:nil];
}

- (IBAction) signatureCancelled: (UIStoryboardSegue *) segue
{
    NSLog(@"Cancelling...");
}

-(IBAction)signatureSaved:(UIStoryboardSegue *)segue {
    
    NSLog(@"Saving...");
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SignatureViewController *signatureViewController = segue.destinationViewController;

    SignatureProcessManager *manager = [SignatureProcessManager sharedManager];
    manager.pageImage = [self.document pageImageWithPageNumber:self.currentPageNumber];
    manager.pageNumber = self.currentPageNumber;
    manager.document = self.document;
}


@end
