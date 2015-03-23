//
//  Document.m
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document



- (instancetype) init
{
    self = [super init];
    if(self)
    {
        _dateCreated = [NSDate date];
        _dateModified = _dateCreated;
    }
    return self;
}

+ (instancetype) documentFromURL: (NSURL *) documentURL
{
    Document *document = [[Document alloc] init];
 
    return document;
}

- (UIImage *) generateDocumentThumbnail
{
    return nil;
}

- (UIImage *) generateDocumentPDF
{
    return nil;
}

- (UIImage *) thumbnailForPage: (NSInteger) pageNumber
{
    return nil;
}

@end
