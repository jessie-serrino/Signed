//
//  SignatureProcess.m
//  Signed
//
//  Created by Jessie Serrino on 3/24/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "SignatureProcessManager.h"
#import "PDFWriter.h"
#import "DocumentManager.h"

@implementation SignatureProcessManager

+ (instancetype)sharedManager
{
    static dispatch_once_t pred;
    static SignatureProcessManager *sharedManager = nil;
    dispatch_once(&pred, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.pdfWriter = [[PDFWriter alloc] init];
    }
    return self;
}

- (void) establishSignature
{
    if(self.signatureMaker)
    {
        Signature *signature = [[Signature alloc] init];
        signature.image = [self.signatureMaker image];
        signature.scale = 0.3;
        signature.page = self.pageNumber;
        
        self.signature = signature;
    }
}

- (void) sealSignature
{
    [self.pdfWriter writeSignature:self.signature toDocument:self.document];
    [[DocumentManager sharedManager] replaceDocumentInCoreData:self.document];
}

@end
