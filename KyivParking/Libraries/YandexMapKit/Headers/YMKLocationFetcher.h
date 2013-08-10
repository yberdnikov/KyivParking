/*
 * YMKLocationFetcher.h
 *
 * This file is a part of the Yandex Map Kit.
 *
 * Version for iOS © 2011-2012 YANDEX
 * 
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.ru/mapkit/
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class YMKMapView;
@class YMKLocationFetcher;

@protocol YMKLocationFetcherDelegate <NSObject>
@required

- (void)locationFetcherDidFetchUserLocation:(YMKLocationFetcher *)locationFetcher;
- (void)locationFetcher:(YMKLocationFetcher *)locationFetcher didFailWithError:(NSError *)error;

@end


@interface YMKLocationFetcher : NSObject

@property (nonatomic, retain) IBOutlet YMKMapView * mapView;
@property (nonatomic, assign) IBOutlet id<YMKLocationFetcherDelegate> delegate;
@property (nonatomic, assign, getter = isFetchingLocation) BOOL fetchingLocation;

- (void)acquireUserLocationFromMapView;

@end
