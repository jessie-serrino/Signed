//
//  PDFWriter.m
//  Signed
//
//  Created by Jessie Serrino on 3/25/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "PDFWriter.h"
#import <UIImage+PDF/UIImage+PDF.h>

@implementation PDFWriter

// For adding the Siganture we need to wite the content on new PDF
+ (NSData *) addSignature:(UIImage *) imgSignature onPDFData:(NSData *)pdfData{
    
    NSMutableData* outputData = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)outputData);
    CFMutableDictionaryRef attrDictionary = NULL;
    attrDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrDictionary, kCGPDFContextTitle, @"My Awesome Document");
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, attrDictionary);
    CFRelease(dataConsumer);
    CFRelease(attrDictionary);
    UIImage* myUIImage = imgSignature;
    CGImageRef pageImage = [myUIImage CGImage];
    CGPDFContextBeginPage(pdfContext, NULL);
    CGContextDrawImage(pdfContext, CGRectMake(0, 0, [myUIImage size].width, [myUIImage size].height), pageImage);
    CGPDFContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);
    CGContextRelease(pdfContext);
    
    UIImage *img2 = [UIImage imageWithPDFData:outputData atHeight:300.0];
    return outputData;
}

@end
