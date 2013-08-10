//
//  DACluster.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/18/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


@interface DACluster : NSObject <YMKAnnotation>

@property (nonatomic, assign) YMKMapCoordinate coordinate;

- (void)addLocation:(NSDictionary *)location;
- (void)removeLocation:(NSDictionary *)location;

- (NSSet *)locations;

- (void)clear; // Remove all locations

- (BOOL)isEqualToCluster:(DACluster *)cluster;

@end
