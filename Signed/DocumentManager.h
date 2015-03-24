//
//  SignatureManager.h
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Document.h"

typedef void (^CompletionBlock)(NSArray *);

@interface DocumentManager : NSObject

@property (nonatomic, strong) NSMutableArray *documents;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Document *currentDocument;

- (void) fetchDocumentsWithCompletion: (CompletionBlock) completionBlock;
+ (instancetype)sharedManager;
- (void) save;
- (void) createDocumentWithURL: (NSURL *) url;


@end
