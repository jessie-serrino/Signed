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
    [self saveDocumentToCoreData:document];
    [self.documents addObject:document];
    self.currentDocument = document;
    
    [self save];
}

- (void) saveDocumentToCoreData: (Document *) document
{
    FileEntity *entity = [NSEntityDescription
                          insertNewObjectForEntityForName:NSStringFromClass([FileEntity class])
                          inManagedObjectContext:self.managedObjectContext];
    entity.data = document.fileData;
    
    [self.managedObjectContext insertObject:entity];
    document.fileLocation = [entity.objectID URIRepresentation];
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

@end
