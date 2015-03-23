//
//  Document.h
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImage+PDF/UIImage+PDF.h>

@import UIKit;

@interface Document : NSObject

@property (nonatomic, strong) NSArray *signatures;
@property (nonatomic, strong) NSURL   *fileLocation;
@property (nonatomic, strong) NSDate  *dateCreated;
@property (nonatomic, strong) NSDate  *dateModified;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) UIImage *documentThumbnail;

+ (instancetype) documentFromURL: (NSURL *) documentURL;
- (UIImage *) generateDocumentThumbnail;
- (NSData *) generateDocumentPDF;
- (UIImage *) thumbnailForPage: (NSInteger) pageNumber;


@end
