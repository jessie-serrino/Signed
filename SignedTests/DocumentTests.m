//
//  DocumentTests.m
//  Signed
//
//  Created by Jessie Serrino on 3/24/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Document.h"
#import "Signature.h"

@interface DocumentTests : XCTestCase



@end

@implementation DocumentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInvalidURLDocNil {
    Document *doc = [Document documentFromURL:nil];
    XCTAssertNil(doc, @"Invalid URL must not be given space");
}

- (void) testCodesAndDecodesProperly
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"doc.dat"];
    
    Document *doc = [[Document alloc] init];
    [NSKeyedArchiver archiveRootObject:doc toFile:filePath];
    Document *newDoc = (Document *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    XCTAssertNotNil(newDoc);
}

- (void) testCodesDecodesFileName
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"doc.dat"];
    
    Document *doc = [[Document alloc] init];
    doc.fileName = @"FileName";
    
    [NSKeyedArchiver archiveRootObject:doc toFile:filePath];
    Document *newDoc = (Document *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertEqualObjects(doc.fileName, newDoc.fileName, @"Does not properly encode and decode filename");
}

- (void) testCodesDecodesFileURL
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"doc.dat"];
    
    Document *doc = [[Document alloc] init];
    doc.fileLocation = [NSURL URLWithString:@"URL"];
    
    [NSKeyedArchiver archiveRootObject:doc toFile:filePath];
    Document *newDoc = (Document *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertEqualObjects(doc.fileLocation, newDoc.fileLocation, @"Does not properly encode and decode file location");
}

- (void) testCodesDecodesDateCreated
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"doc.dat"];
    
    Document *doc = [[Document alloc] init];
    doc.dateCreated = [NSDate date];
    
    [NSKeyedArchiver archiveRootObject:doc toFile:filePath];
    Document *newDoc = (Document *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertEqualObjects(doc.dateCreated, newDoc.dateCreated, @"Does not properly encode and decode date created");
}

- (void) testCodesDecodesDateModified
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"doc.dat"];
    Document *doc = [[Document alloc] init];
    doc.dateModified = [NSDate date];

    [NSKeyedArchiver archiveRootObject:doc toFile:filePath];
    Document *newDoc = (Document *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertEqualObjects(doc.dateModified, newDoc.dateModified, @"Does not properly encode and decode date modified");
}

- (void) testCodesDecodesNumberOfPages
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"doc.dat"];
    Document *doc = [[Document alloc] init];
    doc.numberOfPages = 12341;
    
    [NSKeyedArchiver archiveRootObject:doc toFile:filePath];
    Document *newDoc = (Document *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertEqual(doc.numberOfPages, newDoc.numberOfPages, @"Does not properly encode and decode number of pages");
}



/* Difficult to test because using a PNG representation of the image */
//- (void) testCodesDecodesDocumentThumbnail
//{
//    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"doc.dat"];
//    Document *doc = [[Document alloc] init];
//    doc.documentThumbnail = [UIImage imageNamed:@"AddDocument"];
//    [NSKeyedArchiver archiveRootObject:doc toFile:filePath];
//    Document *newDoc = (Document *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//
//    
//    XCTAssertEqualObjects(doc.documentThumbnail, newDoc.documentThumbnail, @"Document thumbnail must be saved appropriately");
//    
//}

- (void) testCodesDecodesSignatures
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"doc.dat"];
    Document *doc = [[Document alloc] init];
    Signature *sig = [[Signature alloc] init];
    sig.scale = 123412.2342f;
    doc.signatures = [[NSMutableArray alloc] initWithObjects:sig, nil];
    
    [NSKeyedArchiver archiveRootObject:doc toFile:filePath];
    Document *newDoc = (Document *)[NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    XCTAssertNotNil(newDoc.signatures, @"A new doc array has been created");
    XCTAssertEqual(doc.signatures.count, newDoc.signatures.count);
    
    Signature *newSig = newDoc.signatures[0];
    XCTAssertEqual(sig.scale, newSig.scale, @"Does not properly encode and decode signature objects");
}

@end
