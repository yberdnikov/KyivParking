//
//  DAAroundOperation.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/30/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAAroundOperation.h"
#import "DAFetchRequestOperation_Protected.h"
#import "DAParking.h"
#import "DAUtilities.h"


@implementation DAAroundOperation {
	CLLocation *_location;
	CLLocationDistance _radius;
	NSMutableArray *_result;
}

- (id)initWithContext:(NSManagedObjectContext *)context request:(NSFetchRequest *)request
	location:(CLLocation *)location radius:(CLLocationDistance)radius
{
	self = [super initWithContext:context request:request];

	if (nil != self) {
		_location = location;
		_radius = radius;
	}

	return self;
}

- (NSArray *)result
{
	return _result;
}

- (void)main
{
	NSArray *parkings = [self fetch];

	NSPredicate *predicate = [NSPredicate predicateWithBlock:
		^BOOL(DAParking *parking, NSDictionary *bindings)
	{
		parking.location = [[CLLocation alloc] initWithLatitude:parking.latitude
			longitude:parking.longitude];
		parking.distance = [parking.location distanceFromLocation:_location];

		return parking.distance < _radius;
	}];

	_result = [[parkings filteredArrayUsingPredicate:predicate] mutableCopy];

	[_result sortUsingComparator:^NSComparisonResult(DAParking *parking1, DAParking *parking2) {
		CLLocationDistance diff = parking1.distance - parking2.distance;

		return ABS(diff) < kDAComparisonDelta
			? NSOrderedSame
			: diff > 0 ? NSOrderedDescending : NSOrderedAscending;
	}];
	
	[self finish];
}

@end
