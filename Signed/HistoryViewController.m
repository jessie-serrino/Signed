//
//  ViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/18/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "HistoryViewController.h"
#import "DetailViewController.h"

@interface HistoryViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *historyCollectionView;

@end

static NSString * const SegueToDetailView = @"SegueToDetailView";

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchControllers:(id)sender {
    UIStoryboard* detailStoryboard = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UIViewController* detailViewController = [detailStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([DetailViewController class])];
    [self presentViewController: detailViewController animated:YES completion: NULL];
}
- (IBAction)settingsButtonTapped:(UIButton *)sender
{
}
- (IBAction)nextPage:(id)sender {
    
    [self performSegueWithIdentifier:SegueToDetailView sender:self];
}

@end
