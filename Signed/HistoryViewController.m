//
//  ViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/18/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "HistoryViewController.h"
#import "DocumentCollectionViewCell.h"

@interface HistoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *historyCollectionView;

@end

static NSString * const SegueToDetailView = @"SegueToDetailView";

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeCollectionView];
    
}
- (void) initializeCollectionView
{
    [self.historyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DocumentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([DocumentCollectionViewCell class])];

    self.historyCollectionView.delegate = self;
    self.historyCollectionView.dataSource = self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 14;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentCollectionViewCell *cell = (DocumentCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DocumentCollectionViewCell class]) forIndexPath:indexPath];
    return cell;
}





- (IBAction)nextPage:(id)sender {
    
    [self performSegueWithIdentifier:SegueToDetailView sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
