//
//  PDFWriter.h
//  Signed
//
//  Created by Jessie Serrino on 3/25/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Document.h"
#import "Signature.h"


@interface PDFWriter : NSObject

@property (nonatomic, strong) UIImageView   *pageImageView;
@property (nonatomic, strong) UIImageView   *signatureImageView;
@property (nonatomic)         CGPoint       touchOnPage;
@property (nonatomic)         CGFloat       scale;


- (void) writeSignature: (Signature *) signature toDocument: (Document *) document; //withScale: (CGFloat) scale;

@end
