//
//  SignatureTests.m
//  Signed
//
//  Created by Jessie Serrino on 3/24/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Signature.h"

@interface SignatureTests : XCTestCase

@end

@implementation SignatureTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testCodesDecodesPage
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"sign.dat"];
    Signature *sig = [[Signature alloc] init];
    sig.page = 1234;
    
    [NSKeyedArchiver archiveRootObject:sig toFile:filePath];
    Signature *newSig = (Signature *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertEqual(sig.page, newSig.page, @"Does not properly encode and decode page number");
}

- (void) testCodesDecodesScale
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"sign.dat"];
    Signature *sig = [[Signature alloc] init];
    sig.scale = 103.0f;
    [NSKeyedArchiver archiveRootObject:sig toFile:filePath];
    Signature *newSig = (Signature *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];

    XCTAssertEqual(sig.scale, newSig.scale, @"Does not properly encode and decode scale");
}



- (void) testCodesDecodesPosition
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"sign.dat"];
    Signature *sig = [[Signature alloc] init];
    sig.position = CGPointMake(1234,12355);
    
    [NSKeyedArchiver archiveRootObject:sig toFile:filePath];
    Signature *newSig = (Signature *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertEqual(sig.position.x, newSig.position.x, @"Does not properly encode and decode x position");
    XCTAssertEqual(sig.position.y, newSig.position.y, @"Does not properly encode and decode y position");

}

/* Difficult to test because using a PNG representation of the image */
//- (void) testCodesDecodesSignatureImage
//{
//    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"sig.dats"];
//    Signature *sig = [[Signature alloc] init];
//    sig.image = [UIImage imageNamed:@"AddDocument"];
//    [NSKeyedArchiver archiveRootObject:sig toFile:filePath];
//    Signature *newSig = (Signature *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//
//
//    XCTAssertEqualObjects(sig.image, newSig.image, @"Document thumbnail must be saved appropriately");
//
//}

@end
