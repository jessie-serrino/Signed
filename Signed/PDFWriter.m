//
//  PDFWriter.m
//  Signed
//
//  Created by Jessie Serrino on 3/25/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "PDFWriter.h"
#import <UIImage+PDF/UIImage+PDF.h>

static NSString * const tempName = @"temp";
static NSString * const newTempName = @"newTemp";


@interface PDFWriter ()

@property (nonatomic, strong) Document *document;

@end

@implementation PDFWriter

- (void) writeSignature: (UIImageView *) sig toDocument: (Document *) document atPoint: (CGPoint) touch
{
    self.document = document;
    [self writeDataToTemporaryFile];
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)[self temporaryStorage:tempName], kCFURLPOSIXPathStyle, 0);
    
    // open base file
    CGPDFDocumentRef baseDocument = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    [self establishDocument:baseDocument];

    //get amount of pages in base document
    size_t count = CGPDFDocumentGetNumberOfPages(baseDocument);
    
    //for each page in template
    for (size_t pageNumber = 1; pageNumber <= count; pageNumber++) {
        // get bounds of template page
        CGPDFPageRef basePage = CGPDFDocumentGetPage(baseDocument, pageNumber);
        CGRect bounds = CGPDFPageGetBoxRect(basePage, kCGPDFCropBox);
        [self setupPage:basePage withBounds:bounds];

        
    }
    CGPDFDocumentRelease(baseDocument);
    UIGraphicsEndPDFContext();
    
    self.document.fileData = [self retrieveDataFromNewTemporaryFile];
}



- (void) setupPage: (CGPDFPageRef) templatePage withBounds: (CGRect) bounds
{
    UIGraphicsBeginPDFPageWithInfo(bounds, nil);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //flip context due to different origins
    CGContextTranslateCTM(context, 0.0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //copy content of template page on the corresponding page in new file
    CGContextDrawPDFPage(context, templatePage);
    
    //flip context back
    CGContextTranslateCTM(context, 0.0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
}

- (void) establishDocument: (CGPDFDocumentRef) document
{
    NSString *newFilePath = [self temporaryStorage: @"newTemp"];
    
    CGPDFPageRef basePage = CGPDFDocumentGetPage(document, 1);
    CGRect pageBounds = CGPDFPageGetBoxRect(basePage, kCGPDFCropBox);
    UIGraphicsBeginPDFContextToFile(newFilePath, pageBounds, nil);
}

- (void) writeDataToTemporaryFile
{
    NSString *temporaryPath = [self temporaryStorage: tempName];
    [self.document.fileData writeToFile:temporaryPath atomically:YES];
}

- (NSData *) retrieveDataFromNewTemporaryFile
{
    NSString *file = [self temporaryStorage:@"newTemp"];
    return [NSData dataWithContentsOfFile:file];
}

- (NSString *) temporaryStorage: (NSString *) fileName
{
    NSString *tempStoragePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filenamePDF = [fileName stringByAppendingString:@".pdf"];
    return [tempStoragePath  stringByAppendingPathComponent: filenamePDF];
}

@end
