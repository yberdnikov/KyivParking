//
//  DAFetchRequestOperation.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/27/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAFetchRequestOperation.h"
#import "DAFetchRequestOperation_Protected.h"


@implementation DAFetchRequestOperation {
	NSArray *_result;
}

- (id)init
{
	return [self initWithContext:nil request:nil];
}

- (id)initWithContext:(NSManagedObjectContext *)context request:(NSFetchRequest *)request
{
	self = [super init];

	if (nil != self) {
		if (nil != context && nil != request) {
			_request = request;
			_context = context;
		}
		else {
			self = nil;
		}
	}

	return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
   if ([self isCancelled]) {
      self.finished = YES;
      return;
   }
 
   [self willChangeValueForKey:@"isExecuting"];
   [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
   _executing = YES;
   [self didChangeValueForKey:@"isExecuting"];
}

- (void)main
{
	_result = [self fetch];
	[self finish];
}

- (NSArray *)result
{
	return _result;
}

#pragma mark - Protected

- (NSArray *)fetch
{
	NSError *error = nil;
	NSArray *objects = [self.context executeFetchRequest:self.request error:&error];

	if (nil != error) {
		NSLog(@"%@", error);
	}

	return objects;
}

- (void)finish
{
	[self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
