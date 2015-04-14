//
//  SignatureManager.m
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "DocumentManager.h"
#import "FileEntity.h"
#import "NSManagedObjectContext+FetchedObjectWithURI.h"


@implementation DocumentManager

+(instancetype)sharedManager
{
    static dispatch_once_t pred;
    static DocumentManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}


- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void) fetchDocumentsWithCompletion: (CompletionBlock) completionBlock
{
    [self unarchiveDocuments];
    completionBlock(self.documents);
}

- (NSArray *) documents
{
    if(!_documents)
    {
        _documents = [[NSMutableArray alloc] init];
    }
    return _documents;
}


- (void) createDocumentWithURL: (NSURL *) url
{
    Document *document = [Document documentFromURL:url];
    [self addDocument:document];
}

- (void) createDocumentFromClipboard
{
    UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
    
        UIImage *imageToCreate = [clipboard image];
        if(imageToCreate)
        {
            Document *document = [Document documentFromImage:imageToCreate];
            [self addDocument: document];
        }
        else
        {
            Document *document = [Document documentFromImage:[UIImage imageNamed:@"AddDocument"]];
            [self addDocument:document];
        }
}

- (void) addDocument: (Document *) document
{
    [self addDocumentToCoreData:document];
    [self.documents addObject:document];
    self.currentDocument = document;
    [self loadDocument:document];
    
    [self save];
}

- (void) addDocumentToCoreData: (Document *) document
{
    FileEntity *entity = [NSEntityDescription
                          insertNewObjectForEntityForName:NSStringFromClass([FileEntity class])
                          inManagedObjectContext:self.managedObjectContext];
    entity.data = document.fileData;
    
    [self.managedObjectContext insertObject:entity];
    document.fileLocation = [entity.objectID URIRepresentation];
}

-(void) replaceDocumentInCoreData: (Document *) document
{
    if(document.fileLocation)
    {
        FileEntity *file = (FileEntity *) [self.managedObjectContext objectWithURI:document.fileLocation];
        file.data = document.fileData;
    }
}

-(void) removeDocumentInCoreData: (Document *) document
{
    // IMPLEMENT
}

- (void) loadDocument: (Document *) document
{
    if(document.fileLocation)
    {
        FileEntity *file = (FileEntity *) [self.managedObjectContext objectWithURI:document.fileLocation];
        document.fileData = file.data;
    }
    self.currentDocument = document;
}

- (void) unarchiveDocuments
{
    NSArray *savedDocuments = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
    for(Document * doc in savedDocuments)
    {
        [self.documents addObject:doc];
    }
}

- (NSString *) archivePath
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentsPath stringByAppendingPathComponent:@"documents.dat"];
}

- (void) save
{
    [NSKeyedArchiver archiveRootObject:self.documents toFile:[self archivePath]];
}

- (NSURL *) saveToTemporaryFolder
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:self.currentDocument.fileName];
    
    [self.currentDocument.fileData writeToFile:cachePath atomically:YES];
    return [NSURL fileURLWithPath:cachePath];
}

- (void) deleteDocumentsWithIndices: (NSIndexSet *) indices
{
    NSArray *documentsToDelete = [self.documents objectsAtIndexes:indices];
    for(Document *doc in documentsToDelete)
        [self removeDocumentInCoreData:doc];
    
    [self.documents removeObjectsInArray:documentsToDelete];
    [self save];
}


@end
