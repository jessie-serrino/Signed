//
//  SignatureProcess.h
//  Signed
//
//  Created by Jessie Serrino on 3/24/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Document.h"
#import "Signature.h"
#import "SignatureMaker.h"

@interface SignatureProcessManager : NSObject

@property (nonatomic, strong)   Document *document;
@property (nonatomic, strong)   SignatureMaker *signatureMaker;
@property (nonatomic, strong)   Signature *signature;

@property (nonatomic, strong)   UIImage *pageImage;
@property (nonatomic)           NSInteger pageNumber;


+(instancetype)sharedManager;


@end
