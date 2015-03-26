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

- (void) writeSignature: (UIImageView *) sig toDocument: (Document *) document atPoint: (CGPoint) touch;

@end
