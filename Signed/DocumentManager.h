//
//  SignatureManager.h
//  Signed
//
//  Created by Jessie Serrino on 3/22/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentManager : NSObject

@property (nonatomic, weak) NSArray *documents;

+ (instancetype)sharedManager;
- (void) load;
- (void) save;

@end
