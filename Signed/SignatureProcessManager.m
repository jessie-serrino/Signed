//
//  SignatureProcess.m
//  Signed
//
//  Created by Jessie Serrino on 3/24/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "SignatureProcessManager.h"

@implementation SignatureProcessManager

+(instancetype)sharedManager
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
    }
    return self;
}

@end
