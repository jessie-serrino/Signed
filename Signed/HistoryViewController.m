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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (strong, nonatomic) NSMutableIndexSet *selectedItems;
@property (nonatomic)         BOOL deletionMode;

@end

static NSString * const SegueToDetailView = @"SegueToDetailView";
static NSString * const UnselectAllString = @"Unselect All";
static NSString * const SelectString = @"Select";
static NSString * const NewDocumentLabel = @"Add From Clipboard";
static NSString * const NewDocumentImage = @"AddDocument";





@implementation HistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeCollectionView];
    [self prepareDocuments];
    self.historyCollectionView.allowsMultipleSelection = NO;
    self.deletionMode = NO;

}

- (void) prepareDocuments
{
    [[DocumentManager sharedManager] fetchDocumentsWithCompletion:^(NSArray * array)
     {
         _documents = array;
         [self.historyCollectionView reloadData];
         [self.historyCollectionView layoutIfNeeded];
     }];
}



- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return self.documents.count + 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.deletionMode)
    {
        [self openDocumentAtIndexPath:indexPath];
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    else if(indexPath.item == 0)
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    else
    {
        DocumentCollectionViewCell *cell = (DocumentCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
        cell.checkImageView.hidden = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath

{
    if(indexPath.item > 0)
    {
        DocumentCollectionViewCell *cell = (DocumentCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
        cell.checkImageView.hidden = YES;
    }
}


- (void)openDocumentAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 0)
        [self createDocumentFromClipboard];
    else {
        [[DocumentManager sharedManager] loadDocument: (Document *) self.documents[indexPath.item - 1]];
        [self performSegueWithIdentifier:SegueToDetailView sender:self];
    }
}

- (IBAction)trashButtonPressed:(UIBarButtonItem *)sender {
    [self deleteSelectedItems];
    [self selectButtonPressed:sender];
    sender.enabled = NO;
}

- (void) deleteSelectedItems
{
    NSArray *indexPathsToDelete = [self.historyCollectionView indexPathsForSelectedItems];
    
    [self deleteDocumentsInDocumentManager:indexPathsToDelete];
    [self deleteDocumentsInCollectionView:indexPathsToDelete];
}

- (void) deleteDocumentsInDocumentManager: (NSArray *) indexPaths;
{
    DocumentManager *dm = [DocumentManager sharedManager];
    [dm deleteDocumentsWithIndices:[self indexSetFromIndexPaths:indexPaths]];
    self.documents = dm.documents;
}

- (void) deleteDocumentsInCollectionView: (NSArray *) indexPaths
{
    [self.historyCollectionView deleteItemsAtIndexPaths:indexPaths];
    [self.historyCollectionView reloadData];
}

- (NSIndexSet *) indexSetFromIndexPaths: (NSArray *) indexPaths
{
    NSMutableIndexSet * indexes = [[NSMutableIndexSet alloc] init];
    for(NSIndexPath *indexPath in indexPaths)
        if(indexPath.item != 0)
            [indexes addIndex:(indexPath.item - 1)];
    return indexes;
}

- (IBAction)selectButtonPressed:(UIBarButtonItem *)sender {
    
    if([self.selectButton.title isEqualToString:UnselectAllString]) {
        self.selectButton.title = @"Select";
        self.trashButton.enabled = NO;
        
        for(NSIndexPath *indexPath in [self.historyCollectionView indexPathsForSelectedItems])
            [self.historyCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    else if([self.selectButton.title isEqualToString:SelectString]) {
        self.selectButton.title = @"Unselect All";
        self.trashButton.enabled = YES;
    }
    
    self.deletionMode = !self.deletionMode;
    self.historyCollectionView.allowsMultipleSelection = self.deletionMode;
}

- (void) createDocumentFromClipboard {
    [[DocumentManager sharedManager] createDocumentFromClipboard];
    
    [self performSegueWithIdentifier:SegueToDetailView sender:self];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentCollectionViewCell *cell = (DocumentCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DocumentCollectionViewCell class]) forIndexPath:indexPath];

    if(indexPath.item == 0)
    {
        cell.cellImageView.image = [UIImage imageNamed:NewDocumentImage];
        cell.cellLabel.text = NewDocumentLabel;
    }
    else
        [self prepareCell:cell atIndexPath:indexPath];

    return cell;
}

- (void) prepareCell: (DocumentCollectionViewCell *) cell atIndexPath: (NSIndexPath *) indexPath
{
    Document *doc = self.documents[indexPath.item - 1];
    cell.cellImageView.image = doc.documentThumbnail;
    cell.cellLabel.text = doc.fileName;
    
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    cell.layer.shadowRadius = 2.0f;
    cell.layer.shadowOpacity = 0.3f;
    
    if(!self.deletionMode)
        cell.checkImageView.hidden = YES;
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
