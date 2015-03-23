//
//  SignatureManager.m
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "DocumentManager.h"

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
        [self load];
    }
    return self;
}


- (NSArray *) documents
{
    if(!_documents)
    {
        // Retrieve docs
        _documents = [[NSMutableArray alloc] init];
    }
    return _documents;
}


- (void) createDocumentWithURL: (NSURL *) url
{
    Document *document = [Document documentFromURL:url];
    [self.documents addObject:document];
    self.currentDocument = document;
}

- (void) load
{
    if(self.managedObjectContext)
    {
        
    }
}

- (void) save
{

}

@end
