//
//  DAParking.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/11/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAParking.h"


NSString * const kDAParkingEntityName = @"Parking";

NSString * const kDAParkingAddressKey = @"address";
NSString * const kDAParkingAreaKey = @"area";
NSString * const kDAParkingLatitudeKey = @"latitude";
NSString * const kDAParkingLongitudeKey = @"longitude";


@interface DAParking ()

@property (nonatomic, strong) NSNumber *primitiveLatitude;
@property (nonatomic, strong) NSNumber *primitiveLongitude;
@property (nonatomic, strong) NSNumber *primitiveDistance;

@end


@implementation DAParking

@dynamic address, area, latitude, longitude;
@dynamic location, distance;
@dynamic primitiveLatitude, primitiveLongitude, primitiveDistance;


- (BOOL)isEqualToParking:(DAParking *)parking
{
	return nil != parking
		&& YMKMapCoordinateEqualToMapCoordinate([parking coordinate], [self coordinate])
		&& [parking.address isEqualToString:self.address]
		&& [parking.area isEqualToString:self.area];
}

- (YMKMapDegrees)latitude
{
	[self willAccessValueForKey:@"latitude"];
	NSNumber *latitude = self.primitiveLatitude;
	[self didAccessValueForKey:@"latitude"];
	
	return [latitude doubleValue];
}

- (void)setLatitude:(YMKMapDegrees)latitude
{
	[self willChangeValueForKey:@"latitude"];
	self.primitiveLatitude = @(latitude);
	[self didChangeValueForKey:@"latitude"];
}

- (YMKMapDegrees)longitude
{
	[self willAccessValueForKey:@"longitude"];
	NSNumber *longitude = self.primitiveLongitude;
	[self didAccessValueForKey:@"longitude"];
	
	return [longitude doubleValue];
}

- (void)setLongitude:(YMKMapDegrees)longitude
{
	[self willChangeValueForKey:@"longitude"];
	self.primitiveLongitude = @(longitude);
	[self didChangeValueForKey:@"longitude"];
}

- (CLLocationDistance)distance
{
	[self willAccessValueForKey:@"distance"];
	NSNumber *distance = self.primitiveDistance;
	[self didAccessValueForKey:@"distance"];
	
	return [distance doubleValue];
}

- (void)setDistance:(CLLocationDistance)distance
{
	[self willChangeValueForKey:@"distance"];
	self.primitiveDistance = @(distance);
	[self didChangeValueForKey:@"distance"];
}

#pragma mark - YMKGeoObject

- (YMKMapCoordinate)coordinate
{
	return YMKMapCoordinateMake(self.latitude, self.longitude);
}

@end
