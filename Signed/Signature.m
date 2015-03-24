//
//  Signature.m
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "Signature.h"

static NSString * const kPageSigned = @"page";
static NSString * const kSignatureScale = @"scale";
static NSString * const kSignatureImage = @"image";
static NSString * const kSignaturePosition = @"position";

@interface Signature()

@end

@implementation Signature

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.page = [decoder decodeIntegerForKey:kPageSigned];
    self.scale = [decoder decodeFloatForKey:kSignatureScale];
    
    self.position = [decoder decodeCGPointForKey:kSignaturePosition];
    
    NSData *imageData = [decoder decodeObjectForKey:kSignatureImage];
    self.image = [UIImage imageWithData:imageData];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.page forKey:kPageSigned];
    [encoder encodeFloat:self.scale forKey:kSignatureScale];
    [encoder encodeCGPoint:self.position forKey:kSignaturePosition];
    
    [encoder encodeObject:UIImagePNGRepresentation(self.image) forKey:kSignatureImage];

}

@end
