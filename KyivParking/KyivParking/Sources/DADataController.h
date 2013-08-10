//
//  DADataController.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/11/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


@interface DADataController : NSObject

+ (instancetype)sharedDataController;

- (void)importDataFromFileAtURL:(NSURL *)url completion:(void (^)())completion;

- (NSUInteger)numberOfParkingsForRegion:(YMKMapRegion)region;
- (NSArray *)parkingsForRegion:(YMKMapRegion)region;

// Async methods. Running one cancels previous.
- (void)parkingsForRegion:(YMKMapRegion)region completion:(void (^)(NSArray *parkings))completion;
- (void)clustersForRegion:(YMKMapRegion)region completion:(void (^)(NSArray *clusters))completion;

// Parkings are sorted by distance
- (void)parkingsAround:(CLLocation *)location within:(CLLocationDistance)radius completion:(void (^)(NSArray *parkings))completion;
- (void)parkingsAround:(CLLocation *)location completion:(void (^)(NSArray *parkings))completion;

@end
