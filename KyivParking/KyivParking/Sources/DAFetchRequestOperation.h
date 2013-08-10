//
//  DAFetchRequestOperation.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/27/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


@interface DAFetchRequestOperation : NSOperation

// Designated initializer
- (id)initWithContext:(NSManagedObjectContext *)context request:(NSFetchRequest *)request;

- (void)main;

- (NSArray *)result;

@end
