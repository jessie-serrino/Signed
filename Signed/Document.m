//
//  Document.m
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "Document.h"
#import "PDFWriter.h"

static NSString * const kDateCreated = @"dateCreated";
static NSString * const kDateModified = @"dateModified";
static NSString * const kFileName = @"fileName";
static NSString * const kFileLocation = @"fileLocation";
static NSString * const kNumberOfPages = @"numberOfPages";
static NSString * const kDocumentThumbnail = @"documentThumbnail";
static NSString * const kSignaturesArray = @"signatures";


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

+ (instancetype) documentFromUIImage: (UIImage *) image
{
    NSData *fileData = [PDFWriter pdfFromImage:image];
    if(!image || !fileData)
    {
        return nil;
    }
    
    Document *document = [[Document alloc] init];
    document.fileData = fileData;
    document.numberOfPages = 1;
    document.signatures = [[NSMutableArray alloc] init];
    document.documentThumbnail = [document generateDocumentThumbnail];
    document.fileName = [document.dateCreated description];
    
    return document;
}

+ (instancetype) documentFromURL: (NSURL *) documentURL
{
    NSData *fileData = [NSData dataWithContentsOfURL:documentURL];
    if(!fileData)
        return nil;
    
    Document *document = [[Document alloc] init];
    document.fileData = fileData;
    document.numberOfPages = [PDFView pageCountForURL:documentURL];
    document.signatures = [[NSMutableArray alloc] init];
    document.documentThumbnail = [document generateDocumentThumbnail];
    document.fileName = [document fileNameFromURL: documentURL];
    
    return document;
}

- (NSString *) fileNameFromURL: (NSURL *) url
{
    NSArray *stringSegments= [url.absoluteString componentsSeparatedByString:@"/"];
    
    return [[stringSegments lastObject] stringByReplacingOccurrencesOfString:@"%20" withString:@" " ];
}

- (UIImage *) documentThumbnail
{
    if(!_documentThumbnail)
    {
        _documentThumbnail = [self generateDocumentThumbnail];
    }
    return _documentThumbnail;
}


- (void) updateDocument
{
    self.documentThumbnail = [self generateDocumentThumbnail];
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

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.fileName = [decoder decodeObjectForKey:kFileName];
    self.fileLocation = [decoder decodeObjectForKey:kFileLocation];
    
    self.dateCreated = [decoder decodeObjectForKey:kDateCreated];
    self.dateModified = [decoder decodeObjectForKey:kDateModified];
    
    self.numberOfPages = [decoder decodeIntegerForKey:kNumberOfPages];
    
    NSData *thumbnailData = [decoder decodeObjectForKey:kDocumentThumbnail];
    self.documentThumbnail = [UIImage imageWithData:thumbnailData];
    
    self.signatures = [decoder decodeObjectForKey:kSignaturesArray];
    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.fileName forKey:kFileName];
    [encoder encodeObject:self.fileLocation forKey:kFileLocation];
    
    [encoder encodeObject:self.dateCreated forKey:kDateCreated];
    [encoder encodeObject:self.dateModified forKey:kDateModified];
    
    [encoder encodeInteger:self.numberOfPages forKey:kNumberOfPages];
    [encoder encodeObject:UIImagePNGRepresentation(self.documentThumbnail) forKey:kDocumentThumbnail];

    [encoder encodeObject:self.signatures forKey:kSignaturesArray];
}


@end
