//
//  DAFetchRequestOperation_Protected.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/27/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAFetchRequestOperation.h"


@interface DAFetchRequestOperation ()

@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@property (nonatomic, assign, getter=isFinished) BOOL finished;

@property (nonatomic, readonly, strong) NSManagedObjectContext *context;
@property (nonatomic, readonly, strong) NSFetchRequest *request;

- (NSArray *)fetch;

- (void)finish; // Call finish in the end of main implementation to set proper state

@end
