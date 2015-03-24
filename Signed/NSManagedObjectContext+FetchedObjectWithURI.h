//
//  NSManagedObjectContext+FetchedObjectWithURI.h
//  Signed
//
//  Created by Jessie Serrino on 3/24/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import <CoreData/CoreData.h>

/* Credit to CocoaWithLove's Matt Gallagher */

@interface NSManagedObjectContext (FetchedObjectWithURI)
- (NSManagedObject *)objectWithURI:(NSURL *)uri;
@end
