//
//  Document.h
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Document : NSObject

@property (nonatomic, strong) NSArray *signatures;
@property (nonatomic, strong) NSURL   *document;
@property (nonatomic, strong) NSDate  *dateCreated;
@property (nonatomic, strong) NSDate  *dateModified;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) UIImage *thumbnail;

- (UIImage *) generateDocumentThumbnail;
- (UIImage *) generateDocumentPDF;
- (UIImage *) thumbnailForPage: (NSInteger) pageNumber;


@end
