//
//  DACluster.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/18/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DACluster.h"
#import "DADataController.h"


@implementation DACluster {
	NSMutableSet *_locations;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@: %p; coordinate={ %f, %f }, locations=%u>",
		NSStringFromClass([self class]), self, self.coordinate.latitude, self.coordinate.longitude,
		[_locations count]];
}

- (id)init
{
	self = [super init];

	if (nil != self) {
		_locations = [NSMutableSet new];
	}

	return self;
}

- (void)addLocation:(NSDictionary *)location
{
	[_locations addObject:location];
}

- (void)removeLocation:(NSDictionary *)location
{
	[_locations removeObject:location];
}

- (NSSet *)locations
{
	return _locations;
}

- (NSUInteger)numberOfLocations
{
	return [_locations count];
}

- (void)clear
{
	[_locations removeAllObjects];
}

- (BOOL)isEqualToCluster:(DACluster *)cluster
{
	return YMKMapCoordinateEqualToMapCoordinate(cluster.coordinate, self.coordinate)
		&& [cluster numberOfLocations] == [self numberOfLocations];
}

@end
