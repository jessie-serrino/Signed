//
//  DocumentEntity.h
//  Signed
//
//  Created by Jessie Serrino on 3/24/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FileEntity : NSManagedObject

@property (nonatomic, retain) NSData * data;

@end
