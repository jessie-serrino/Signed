//
//  ViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/18/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "HistoryViewController.h"
#import "DocumentCollectionViewCell.h"
#import "DocumentManager.h"

@interface HistoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *historyCollectionView;
@property (strong, nonatomic) NSArray *documents;

@end

static NSString * const SegueToDetailView = @"SegueToDetailView";

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeCollectionView];
    [[DocumentManager sharedManager] fetchDocumentsWithCompletion:^(NSArray * array)
     {
         _documents = array;
         [self.historyCollectionView reloadData];
         [self.historyCollectionView layoutIfNeeded];
         NSLog(@"Document count");
     }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.historyCollectionView reloadData];
    [self.historyCollectionView layoutIfNeeded];
}

- (void) initializeCollectionView
{
    [self.historyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DocumentCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([DocumentCollectionViewCell class])];

    self.historyCollectionView.delegate = self;
    self.historyCollectionView.dataSource = self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.documents.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentCollectionViewCell *cell = (DocumentCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DocumentCollectionViewCell class]) forIndexPath:indexPath];

        Document *doc = self.documents[indexPath.item];
        cell.cellImageView.image = doc.documentThumbnail;
        cell.cellLabel.text = doc.fileName;

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[DocumentManager sharedManager] loadDocument: (Document *) self.documents[indexPath.item]];
    [self performSegueWithIdentifier:SegueToDetailView sender:self];
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
