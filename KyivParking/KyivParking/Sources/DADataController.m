//
//  DADataController.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/11/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DADataController.h"

#import "DAUtilities.h"
#import "DAParking.h"
#import "DACluster.h"
#import "DAXMLParserOperation.h"
#import "DAFetchRequestOperation.h"
#import "DAClustererOperation.h"
#import "DAAroundOperation.h"


static NSString * const kDAParkingsFileName = @"Parkings";
static NSString * const kDAPersistantStoreFileName = @"parkings.db";


@interface DADataController ()

- (NSURL *)persistantStoreFileURL;
- (NSPredicate *)predicateForRegion:(YMKMapRegion)region;
- (void)performOperation:(DAFetchRequestOperation *)operation
	completion:(void (^)(NSArray *result))completion;

@end


@implementation DADataController {
	NSPersistentStoreCoordinator *_persistentStoreCoordinator;
	NSManagedObjectContext *_mainQueueContext;
	NSManagedObjectContext *_privateQueueContext;

	NSOperationQueue *_queue;
}

+ (instancetype)sharedDataController
{
	static DADataController *sharedDataController;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        sharedDataController = [self new];
    });

    return sharedDataController;
}

- (id)init
{
	self = [super init];

	if (nil != self) {
		NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

		_mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		[_mainQueueContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
		[_mainQueueContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
		[_mainQueueContext setUndoManager:nil];

		_privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
		[_privateQueueContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
		[_privateQueueContext setUndoManager:nil];

		NSURL *url = [self persistantStoreFileURL];
		NSError *error = nil;
		[_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
			URL:url options:nil error:&error];

		if (nil != error) {
			NSLog(@"%@", error);
		}

		_queue = [NSOperationQueue new];
		[_queue setMaxConcurrentOperationCount:1];
	}

	return self;
}

- (BOOL)shouldImportData
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDAParkingEntityName];
	[request setIncludesSubentities:NO];
	[request setIncludesPropertyValues:NO];

	NSError *error = nil;
	NSArray *results = [_mainQueueContext executeFetchRequest:request error:&error];

	if (nil != error) {
		NSLog(@"%@", error);
	}

	return 0 == [results count];
}

- (void)importDataFromFileAtURL:(NSURL *)url completion:(void (^)())completion
{
	static const NSUInteger kBatchSize = 50;

	NSManagedObjectContext *context = [[NSManagedObjectContext alloc]
		initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	[context setPersistentStoreCoordinator:_persistentStoreCoordinator];
	[context setUndoManager:nil];

	__block NSUInteger counter = 0;

	id observer = [[NSNotificationCenter defaultCenter]
		addObserverForName:NSManagedObjectContextDidSaveNotification
		object:context queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	{
		NSLog(@"saved: %u", counter);
		[_mainQueueContext mergeChangesFromContextDidSaveNotification:note];
		[_privateQueueContext mergeChangesFromContextDidSaveNotification:note];
	}];

	DAXMLParserOperation *operation = [[DAXMLParserOperation alloc] initWithFileURL:url
		elementHandler:^(NSDictionary *element)
		{
			DAParking *parking = [NSEntityDescription
				insertNewObjectForEntityForName:kDAParkingEntityName
				inManagedObjectContext:context];
			parking.address = element[kDAParkingAddressKey];
			parking.area = element[kDAParkingAreaKey];
			parking.latitude = [element[kDAParkingLatitudeKey] doubleValue];
			parking.longitude = [element[kDAParkingLongitudeKey] doubleValue];

			counter += 1;

			if (0 == counter % kBatchSize) {
				NSError *error = nil;
				[context save:&error];

				if (nil != error) {
					NSLog(@"%@", error);
				}
			}
		}];

	[operation setCompletionBlock:^{
		NSError *error = nil;
		[context save:&error];

		if (nil != error) {
			NSLog(@"%@", error);
		}

		[[NSNotificationCenter defaultCenter] removeObserver:observer];

		if (NULL != completion) {
			completion();
		}
	}];

	if (nil != operation) {
		NSOperationQueue *queue = [NSOperationQueue new];
		[queue setMaxConcurrentOperationCount:1];
		[queue addOperation:operation];
	}
}

- (NSUInteger)numberOfParkingsForRegion:(YMKMapRegion)region
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDAParkingEntityName];
	[request setPredicate:[self predicateForRegion:region]];

	NSError *error = nil;
	NSUInteger count = [_mainQueueContext countForFetchRequest:request error:&error];

	if (nil != error) {
		NSLog(@"%@", error);
	}

	return count;
}

- (NSArray *)parkingsForRegion:(YMKMapRegion)region
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDAParkingEntityName];
	[request setPredicate:[self predicateForRegion:region]];

	NSError *error = nil;
	NSArray *parkings = [_mainQueueContext executeFetchRequest:request error:&error];

	if (nil != error) {
		NSLog(@"%@", error);
	}

	return parkings;
}

- (void)parkingsForRegion:(YMKMapRegion)region completion:(void (^)(NSArray *parkings))completion
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDAParkingEntityName];
	[request setPredicate:[self predicateForRegion:region]];

	DAFetchRequestOperation *operation = [[DAFetchRequestOperation alloc]
		initWithContext:_privateQueueContext request:request];
	[self performOperation:operation completion:completion];
}

- (void)clustersForRegion:(YMKMapRegion)region completion:(void (^)(NSArray *clusters))completion
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDAParkingEntityName];
	[request setPredicate:[self predicateForRegion:region]];
	[request setResultType:NSDictionaryResultType];
	[request setPropertiesToFetch:@[ kDAParkingLatitudeKey, kDAParkingLongitudeKey ]];

	DAClustererOperation *operation = [[DAClustererOperation alloc]
		initWithContext:_privateQueueContext request:request region:region];
	[self performOperation:operation completion:completion];
}

- (void)parkingsAround:(CLLocation *)location within:(CLLocationDistance)radius
	completion:(void (^)(NSArray *parkings))completion
{
	YMKMapRect rect = YMKMapRectMakeWithCenterAndMeters(location.coordinate, radius);
	YMKMapRegion region = YMKMapRegionFromMapRect(rect);

	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDAParkingEntityName];
	[request setPredicate:[self predicateForRegion:region]];

	DAAroundOperation *operation = [[DAAroundOperation alloc] initWithContext:_privateQueueContext
		request:request location:location radius:radius];
	[self performOperation:operation completion:completion];
}

- (void)parkingsAround:(CLLocation *)location completion:(void (^)(NSArray *parkings))completion
{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kDAParkingEntityName];
	[request setPredicate:[self predicateForRegion:YMKMapRegionEarth]];

	DAAroundOperation *operation = [[DAAroundOperation alloc] initWithContext:_privateQueueContext
		request:request location:location radius:DBL_MAX];
	[self performOperation:operation completion:completion];
}

#pragma mark - Private

- (NSURL *)persistantStoreFileURL
{
	NSURL *directory = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
			inDomains:NSUserDomainMask] lastObject];
	return [directory URLByAppendingPathComponent:kDAPersistantStoreFileName];
}

- (NSPredicate *)predicateForRegion:(YMKMapRegion)region
{
	CLLocationDegrees delta = kDAComparisonDelta;

	YMKMapCoordinate topLeft = YMKMapRegionGetTopLeftCoordinate(region);
	YMKMapCoordinate bottomRight = YMKMapRegionGetBottomRightCoordinate(region);

	NSExpression *latKeyExpression = [NSExpression expressionForKeyPath:kDAParkingLatitudeKey];
	NSExpression *latLowerExpression = [NSExpression expressionForConstantValue:
		@(bottomRight.latitude - delta)];
	NSExpression *latUpperExpression = [NSExpression expressionForConstantValue:
		@(topLeft.latitude + delta)];
	NSExpression *latRangeExpression = [NSExpression expressionForAggregate:@[
		latLowerExpression, latUpperExpression
	]];

	NSExpression *lonKeyExpression = [NSExpression expressionForKeyPath:kDAParkingLongitudeKey];
	NSExpression *lonLowerExpression = [NSExpression expressionForConstantValue:
		@(topLeft.longitude - delta)];
	NSExpression *lonUpperExpression = [NSExpression expressionForConstantValue:
		@(bottomRight.longitude + delta)];
	NSExpression *lonRangeExpression = [NSExpression expressionForAggregate:@[
		lonLowerExpression, lonUpperExpression
	]];

	NSPredicate *latPredicate = [NSComparisonPredicate predicateWithLeftExpression:latKeyExpression
		rightExpression:latRangeExpression modifier:NSDirectPredicateModifier
		type:NSBetweenPredicateOperatorType options:0];
	NSPredicate *lonPredicate = [NSComparisonPredicate predicateWithLeftExpression:lonKeyExpression
		rightExpression:lonRangeExpression modifier:NSDirectPredicateModifier
		type:NSBetweenPredicateOperatorType options:0];

	return [NSCompoundPredicate andPredicateWithSubpredicates:@[ latPredicate, lonPredicate ]];
}

- (void)performOperation:(DAFetchRequestOperation *)operation
	completion:(void (^)(NSArray *result))completion
{
	if (nil != operation) {
		__weak DAFetchRequestOperation *weak_operation = operation;

		[operation setCompletionBlock:^{
			if (![weak_operation isCancelled]) {
				dispatch_sync(dispatch_get_main_queue(), ^{
					if (NULL != completion) {
						completion([weak_operation result]);
					}
				});
			}
		}];

		[_queue cancelAllOperations];
		[_queue addOperation:operation];
	}
}

@end
