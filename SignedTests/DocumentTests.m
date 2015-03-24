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
    
    XCTAssertEqualObjects(doc.dateModified, newDoc.dateModified, @"Does not properly encode and decode date created");
}



@end
