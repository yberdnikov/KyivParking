/*
 * YMKConfiguration.h
 *
 * This file is a part of the Yandex Map Kit.
 *
 * Version for iOS © 2011-2012 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.ru/mapkit/
 */

#import <Foundation/Foundation.h>
#import "YMKMapStructs.h"

@interface NSValue (YMKMapCoordinate)

/**
 @abstract Creates and returns a value object that contains the specified coordinate.
 @param coordinate The value for the new object.
 */
+ (NSValue *)valueWithYMKMapCoordinate:(YMKMapCoordinate)coordinate;

/**
 @abstract Returns a coordinate representing the data in the receiver.
 @discussion Objective-C type carried by receiver doesn't match YMKMapCoordinate
 then this method returns YMKMapCoordinateInvalid.
 @return A coordinate containing the receiver’s value.
 */
- (YMKMapCoordinate)YMKMapCoordinateValue;

@end

