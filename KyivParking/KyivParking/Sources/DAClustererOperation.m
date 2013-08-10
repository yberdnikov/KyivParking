//
//  DAClustererOperation.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/24/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAClustererOperation.h"
#import "DAFetchRequestOperation_Protected.h"
#import "DACluster.h"
#import "DAParking.h"
#import "DAUtilities.h"


#define RANDOM_CLUSTERS 1


YMKMapCoordinate DAGetYMKMapCoordinateFromLocation(NSDictionary *location); // Get YMKMapCoordinate from location dictionary containing latitude and longitude keys


@implementation DAClustererOperation {
	YMKMapRegion _region;
	NSMutableArray *_clusters;
}

- (id)initWithContext:(NSManagedObjectContext *)context request:(NSFetchRequest *)request
	region:(YMKMapRegion)region
{
	self = [super initWithContext:context request:request];

	if (nil != self) {
		_region = region;
	}

	return self;
}

- (NSArray *)result
{
	return _clusters;
}

- (void)main
{
	static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
		srand(time(NULL));
    });

	static const int kDANumberOfClusters = 3;

	_clusters = [[NSMutableArray alloc] initWithCapacity:kDANumberOfClusters * kDANumberOfClusters];

	YMKMapCoordinate topLeft = YMKMapRegionGetTopLeftCoordinate(_region);
	YMKMapRegionSize span = YMKMapRegionSizeMake(
		_region.span.latitudeDelta / kDANumberOfClusters,
		_region.span.longitudeDelta / kDANumberOfClusters);

	for (int i = 0; i < kDANumberOfClusters; i++) {
		for (int j = 0; j < kDANumberOfClusters; j++) {
			DACluster *cluster = [DACluster new];
			[_clusters addObject:cluster];

			YMKMapDegrees latitude = topLeft.latitude - span.latitudeDelta * i;
			YMKMapDegrees longitude = topLeft.longitude + span.longitudeDelta * j;

#if RANDOM_CLUSTERS
			cluster.coordinate = YMKMapCoordinateMake(
				RANDOM_IN_RANGE(latitude, latitude - span.latitudeDelta),
				RANDOM_IN_RANGE(longitude, longitude + span.longitudeDelta));
#else
			cluster.coordinate = YMKMapCoordinateMake(
				latitude - span.latitudeDelta / 2,
				longitude + span.longitudeDelta / 2);
#endif
		}
	}

	DACluster *(^nearestClusterForLocation)(NSDictionary *) = ^DACluster *(NSDictionary *location) {
		__block DACluster *nearest = nil;
		__block double nearestDistance = HUGE;

		YMKMapCoordinate coordinate = DAGetYMKMapCoordinateFromLocation(location);

		[_clusters enumerateObjectsUsingBlock:^(DACluster *cluster, NSUInteger idx, BOOL *stop) {
			double distance = EUCLIDEAN_DISTANCE(coordinate, cluster.coordinate);

			if (distance < nearestDistance) {
				nearestDistance = distance;
				nearest = cluster;
			}
		}];

		return nearest;
	};

	NSArray *locations = [self fetch];

	__block BOOL updated = NO;
	static const int kDANumberOfIterations = 10;
	int counter = 0;

	do {
		updated = NO;

		[_clusters enumerateObjectsUsingBlock:^(DACluster *cluster, NSUInteger idx, BOOL *stop) {
			[cluster clear];
			*stop = [self isCancelled];
		}];

		[locations enumerateObjectsUsingBlock:^(NSDictionary *location, NSUInteger idx, BOOL *stop) {
			DACluster *cluster = nearestClusterForLocation(location);
			[cluster addLocation:location];
			*stop = [self isCancelled];
		}];

		[_clusters enumerateObjectsUsingBlock:^(DACluster *cluster, NSUInteger idx, BOOL *stop) {
			if ([[cluster locations] count] > 0) {
				__block YMKMapCoordinate mean = YMKMapCoordinateZero;

				[[cluster locations] enumerateObjectsUsingBlock:^(NSDictionary *location, BOOL *stop) {
					YMKMapCoordinate coordinate = DAGetYMKMapCoordinateFromLocation(location);
					mean.latitude += coordinate.latitude;
					mean.longitude += coordinate.longitude;
				}];

				mean.latitude /= [[cluster locations] count];
				mean.longitude /= [[cluster locations] count];

				if (!YMKMapCoordinateEqualToMapCoordinate(mean, cluster.coordinate)) {
					updated = YES;
					cluster.coordinate = mean;
				}
			}

			*stop = [self isCancelled];
		}];

		counter += 1;

	} while (updated && counter < kDANumberOfIterations && ![self isCancelled]);

	[super main];
}


@end


YMKMapCoordinate DAGetYMKMapCoordinateFromLocation(NSDictionary *location)
{
	return YMKMapCoordinateMake([location[kDAParkingLatitudeKey] doubleValue],
		[location[kDAParkingLongitudeKey] doubleValue]);
}
