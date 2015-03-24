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
    NSError *error;
    NSData *fileData = [NSData dataWithContentsOfURL:documentURL options:NSDataReadingMappedAlways error:&error];
    if(error || !fileData)
        return nil;
    
    Document *document = [[Document alloc] init];
    document.fileData = fileData;
    document.numberOfPages = [PDFView pageCountForURL:documentURL];
    document.signatures = [[NSMutableArray alloc] init];
    document.documentThumbnail = [document generateDocumentThumbnail];
    
    return document;
}

- (UIImage *) documentThumbnail
{
    if(!_documentThumbnail)
    {
        _documentThumbnail = [self generateDocumentThumbnail];
    }
    return _documentThumbnail;
}

- (UIImage *) generateDocumentThumbnail
{
    CGFloat width = 80;
    return [UIImage imageWithPDFData:self.fileData atWidth:width atPage:1];
}

- (NSData *) generateDocumentPDF
{
    return nil;
}

- (UIImage *) pageImageWithPageNumber: (NSInteger) pageNumber;
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return [UIImage imageWithPDFData:self.fileData atWidth:width atPage:pageNumber];
}

- (UIImage *) thumbnailImageWithPageNumber:(NSInteger)pageNumber
{
    CGFloat width = 80;
    return [UIImage imageWithPDFData:self.fileData atWidth:width atPage: pageNumber];
}


@end
