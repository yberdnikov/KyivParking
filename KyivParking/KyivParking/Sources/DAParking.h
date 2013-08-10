//
//  DAParking.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/11/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


@interface DAParking : NSManagedObject <YMKAnnotation>

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, assign) YMKMapDegrees latitude;
@property (nonatomic, assign) YMKMapDegrees longitude;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLLocationDistance distance;

- (BOOL)isEqualToParking:(DAParking *)parking;

@end


extern NSString * const kDAParkingEntityName;

extern NSString * const kDAParkingAddressKey;
extern NSString * const kDAParkingAreaKey;
extern NSString * const kDAParkingLatitudeKey;
extern NSString * const kDAParkingLongitudeKey;
