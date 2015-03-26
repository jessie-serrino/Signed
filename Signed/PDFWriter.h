//
//  PDFWriter.h
//  Signed
//
//  Created by Jessie Serrino on 3/25/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PDFWriter : NSObject

+ (NSData *) addSignature:(UIImage *) imgSignature onPDFData:(NSData *)pdfData;

@end
