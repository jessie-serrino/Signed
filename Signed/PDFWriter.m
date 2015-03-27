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


+ (NSData *) pdfFromImage: (UIImage *) image
{
    NSString *newFilePath = [self temporaryStorage: @"newTemp"];
    
    CGRect pageBounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginPDFContextToFile(newFilePath, pageBounds, nil);
    
    UIGraphicsBeginPDFPageWithInfo(pageBounds, nil);
    [image drawInRect:pageBounds];

    UIGraphicsEndPDFContext();
    NSData * data = [PDFWriter retrieveDataFromNewTemporaryFile];

    return data;
}

- (void) writeSignature: (Signature *) signature toDocument: (Document *) document //withScale: (CGFloat) scale //atPoint: (CGPoint) touch
{
    self.document = document;
    [self writeDataToTemporaryFile];
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)[PDFWriter temporaryStorage:tempName], kCFURLPOSIXPathStyle, 0);
    
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

        if(pageNumber == signature.page)
        {
            CGRect visibleSignatureFrame = [self frameForImageinImageViewAspectFit:self.signatureImageView];
            
            
            CGRect rect = [self frameForImageinImageViewAspectFit:self.pageImageView];

            CGPoint offsetAdjusted = [self pointAdjustedForTouchOffset:self.touchOnPage withImageViewRect:rect];
            CGPoint point = [self scalePoint:offsetAdjusted fromSize:rect.size toSize:bounds.size];
            
            CGFloat absoluteScale = [self scaleToPDF:bounds.size viewImageSize:visibleSignatureFrame.size andImage:self.signatureImageView.image]*self.scale;
            
            UIImage *signatureImage = self.signatureImageView.image;
            
            CGRect signatureRect = CGRectMake(point.x, point.y, signatureImage.size.width*absoluteScale, signatureImage.size.height*absoluteScale);
            
            CGRect signatureCenteredRect = [self signatureCenteredRect:signatureRect];
            
            [signatureImage drawInRect:signatureCenteredRect];

        }
    }
    CGPDFDocumentRelease(baseDocument);
    UIGraphicsEndPDFContext();
    
    self.document.fileData = [PDFWriter retrieveDataFromNewTemporaryFile];
    [self.document updateDocument];
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
    NSString *newFilePath = [PDFWriter temporaryStorage: @"newTemp"];
    
    CGPDFPageRef basePage = CGPDFDocumentGetPage(document, 1);
    CGRect pageBounds = CGPDFPageGetBoxRect(basePage, kCGPDFCropBox);
    UIGraphicsBeginPDFContextToFile(newFilePath, pageBounds, nil);
}

- (void) writeDataToTemporaryFile
{
    NSString *temporaryPath = [PDFWriter temporaryStorage: tempName];
    [self.document.fileData writeToFile:temporaryPath atomically:YES];
}

+ (NSData *) retrieveDataFromNewTemporaryFile
{
    NSString *file = [PDFWriter temporaryStorage:@"newTemp"];
    return [NSData dataWithContentsOfFile:file];
}

+ (NSString *) temporaryStorage: (NSString *) fileName
{
    NSString *tempStoragePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filenamePDF = [fileName stringByAppendingString:@".pdf"];
    return [tempStoragePath  stringByAppendingPathComponent: filenamePDF];
}

/* Scaling functions */

- (CGFloat) scaleToPDF: (CGSize) pdfSize viewImageSize: (CGSize) viewImageSize andImage: (UIImage *) image
{
    return  [self absoluteImage:image scaleToImageView:viewImageSize] * [self imageView:viewImageSize scaleToPDF:pdfSize];
}


- (CGFloat) imageView: (CGSize) imageViewSize scaleToPDF: (CGSize) pdfSize
{
    return pdfSize.width / imageViewSize.width;
}

- (CGFloat) absoluteImage: (UIImage *) image scaleToImageView: (CGSize) imageViewSize
{
    return  imageViewSize.width / image.size.width;
}

- (CGRect) signatureCenteredRect: (CGRect) oldRect
{
    CGPoint newOrigin = CGPointMake(oldRect.origin.x - oldRect.size.width/2, oldRect.origin.y - oldRect.size.height/2);
    return CGRectMake(newOrigin.x, newOrigin.y, oldRect.size.width, oldRect.size.height);
}

- (CGPoint) scalePoint: (CGPoint) point fromSize: (CGSize) oldRect toSize: (CGSize) newRect
{
    CGFloat scale = newRect.width / oldRect.width;
    return CGPointMake(point.x * scale, point.y * scale);
}

- (CGPoint) pointAdjustedForTouchOffset: (CGPoint) touch withImageViewRect: (CGRect) rect
{
    return CGPointMake(touch.x - rect.origin.x, touch.y - rect.origin.y);
}

-(CGRect)frameForImageinImageViewAspectFit:(UIImageView*)imageView
{
    UIImage *image = imageView.image;
    float imageRatio = image.size.width / image.size.height;
    
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio)
    {
        float scale = imageView.frame.size.height / image.size.height;
        
        float width = scale * image.size.width;
        
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else
    {
        float scale = imageView.frame.size.width / image.size.width;
        
        float height = scale * image.size.height;
        
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}

@end
