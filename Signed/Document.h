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

@interface Document : NSObject <NSCoding> // Maybe NSSecureCoding in the future
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSURL   *fileLocation;

@property (nonatomic, strong) NSDate  *dateCreated;
@property (nonatomic, strong) NSDate  *dateModified;

@property (nonatomic)         NSInteger numberOfPages;

@property (nonatomic, strong) UIImage *documentThumbnail;
@property (nonatomic, strong) NSMutableArray *signatures;



@property (nonatomic, strong) NSData  *fileData; // To remove


+ (instancetype) documentFromURL: (NSURL *) documentURL;
+ (instancetype) documentFromUIImage: (UIImage *) image;
- (void) updateDocument;
- (NSData *) generateDocumentPDF;
- (UIImage *) pageImageWithPageNumber: (NSInteger) pageNumber;
- (UIImage *) thumbnailImageWithPageNumber: (NSInteger) pageNumber;


@end
