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



@interface DocumentManager : NSObject

@property (nonatomic, strong) NSMutableArray *documents;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Document *currentDocument;

+ (instancetype)sharedManager;
- (void) createDocumentWithURL: (NSURL *) url;


@end
