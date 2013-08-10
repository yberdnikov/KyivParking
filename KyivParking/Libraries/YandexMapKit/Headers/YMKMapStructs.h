/*
 * YMKMapStructs.h
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

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma mark - Types
    
    typedef CLLocationCoordinate2D YMKMapCoordinate;
    typedef CLLocationDegrees YMKMapDegrees;
    typedef CLLocationAccuracy YMKMapAccuracy;
    typedef CLLocationSpeed YMKMapSpeed;
    typedef CLLocationDirection YMKMapDirection;
    typedef CLLocationDistance YMKMapDistance;
    
    typedef enum {
        YMKMapTypeInvalid = 0,
        YMKMapTypeMap = 1,
        YMKMapTypeSattelite = 2,
        YMKMapTypeWiki = 3,
        YMKMapTypeHybrid = 4
    } YMKMapType DEPRECATED_ATTRIBUTE;
    
    /**
     Represents a geographical coordinate (latitude or longitude) in the degrees-minutes-seconds (DMS) format.
     */
    typedef struct {
        short degrees;
        unsigned short minutes;
        float seconds;
    } YMKCoordinateComponents;
    
    /**
     Defines a point on the map.
     */
    typedef struct {
        long long int x;
        long long int y;
    } YMKMapPoint;
    
    /**
     Defines the size of YMKMapRegion instance.
     */
    typedef struct {
        YMKMapDegrees latitudeDelta;    /**< the vertical distance of the region */
        YMKMapDegrees longitudeDelta;   /**< the horizontal distance of the region */
    } YMKMapRegionSize;
    
    /**
     Defines a map region.
     */
    typedef struct {
        YMKMapCoordinate center;    /**< the coordinate of the region center */
        YMKMapRegionSize span;      /**< the region size */
    } YMKMapRegion;
    
    /**
     Defines a rectangular area on the map.
     */
    typedef struct {
        YMKMapCoordinate topLeft;       /**< the coordinate of the top left corner of the rectangle  */
        YMKMapCoordinate bottomRight;   /**< the coordinate of the bottom right corner of the rectangle */
    } YMKMapRect;
    
    /**
     Defines map view port
     */
    typedef struct {
        YMKMapRect mapRect;     /**< current map rectangular area covered by view port */
        NSUInteger zoomLevel;   /**< current map zoom level */        
    } YMKMapViewPort;
    
#pragma mark - Consts
    
    extern YMKMapDegrees const kYMKMapStructsComparisonAccuracy;
    extern YMKMapDegrees const kYMKMapStructsCoordinateLatitudeMinValue;
    extern YMKMapDegrees const kYMKMapStructsCoordinateLatitudeMaxValue;
    extern YMKMapDegrees const kYMKMapStructsCoordinateLongitudeMinValue;
    extern YMKMapDegrees const kYMKMapStructsCoordinateLongitudeMaxValue;
    extern YMKMapDegrees const kYMKMapRegionSizeDeltaLatitudeMinValue;
    extern YMKMapDegrees const kYMKMapRegionSizeDeltaLatitudeMaxValue;
    extern YMKMapDegrees const kYMKMapRegionSizeDeltaLongitudeMinValue;
    extern YMKMapDegrees const kYMKMapRegionSizeDeltaLongitudeMaxValue;
    
#pragma mark - YMKMapDegrees Consts and Functions
    
    /**
     Defines invalid YMKMapDegrees value.
     */
    extern YMKMapDegrees const YMKMapDegreesInvalid;
    
    /**
     Converts degrees to the string representation.
     @param degrees the coordinate in degrees
     @return the string representation of the coordinate in degrees
     */
    extern NSString * NSStringFromMapDegrees(YMKMapDegrees degrees);
    
    /**
     Returns the degrees value of the receiver’s text as a YMKMapDegrees. 
     @return The degrees value of the receiver’s text as a YMKMapDegrees. Returns 0.0 if the receiver is not a valid text representation of a YMKMapDegrees.
     */
    extern YMKMapDegrees YMKMapDegreesFromString(NSString *string);
    
#pragma mark - YMKMapCoordinate Consts and Functions
    
    /**
     Specifies a point on the map with coordinate (0.0; 0.0).
     */
    extern YMKMapCoordinate const YMKMapCoordinateZero;
    
    /**
     Used to specify an invalid YMKMapCoordinate.
     */
    extern YMKMapCoordinate const YMKMapCoordinateInvalid;
    
    /**
     Creates a geographical point with specified coordinates.
     @param latitude the latitude of the point
     @param longitude the longitude of the point
     @return the geographical point with the specified coordinates
     */
    extern YMKMapCoordinate YMKMapCoordinateMake(YMKMapDegrees latitude, YMKMapDegrees longitude);
    
    /**
     Compares two geographical coordinates for equality.
     @param ll1 the first coordinate
     @param ll2 the second coordinate
     @return YES if coordinates are equal, NO - otherwise
     */
    extern BOOL YMKMapCoordinateEqualToMapCoordinate(YMKMapCoordinate ll1, YMKMapCoordinate ll2);
    
    /**
     Checks if the specified map coordinate is a zero coordinate (YMKMapCoordinateZero).
     @param ll a map coordinate
     @return YES if the map coordinate is a zero coordinate, NO - otherwise
     @include
     */
    extern BOOL YMKMapCoordinateIsZero(YMKMapCoordinate ll);
    
    /**
     Checks if the specified map coordinate is invalid (YMKMapCoordinateInvalid).
     @param ll a map coordinate 
     @return YES if the map coordinate is invalid, NO - otherwise
     */
    extern BOOL YMKMapCoordinateIsValid(YMKMapCoordinate ll);
    
    /**
     Converts a map coordinate to the dictionary.
     @param ll a map coordinate
     @return the dictionary
     */
    extern NSDictionary * NSDictionaryFromMapCoordinate(YMKMapCoordinate ll);
    
    /**
     Creates a map coordinate from the dictionary.
     The dictionary should contain two keys: latitude and longitude which values should be of type double.
     In general, you should use this function only to convert dictionaries that were previously created using the NSDictionaryFromMapCoordinate function.
     @param dict the dictionary
     @return the created coordinate
     */
    extern YMKMapCoordinate YMKMapCoordinateFromDictionary(NSDictionary * dict);
    
    /**
     Returns the string representation of a map coordinate.
     @param ll a map coordinate
     @return the string representation of the specified coordinate
     */
    extern NSString * NSStringFromMapCoordinate(YMKMapCoordinate ll);
    
    /**
     Creates a map coordinate from string. 
     In general, you should use this function only to convert strings that were previously created using the NSStringFromMapCoordinate function.
     @param string the string
     @return the created coordinate. Returns YMKMapCoordinateInvalid if the receiver is not a valid text representation of a YMKMapCoordinate.
     */
    extern YMKMapCoordinate YMKMapCoordinateFromString(NSString *string);
    
    /**
     Returns the human readable string representation (degrees/minutes/seconds) of a map coordinate.
     @param ll a map coordinate
     @return the string representation of the specified coordinate
     */
    extern NSString * NSHumanReadableStringFromMapCoordinate(YMKMapCoordinate ll);
    
#pragma mark - YMKCoordinateComponents Functions
    
    /**
     Splits a geographical coordinate into components (degrees, minutes and seconds).
     @param degrees a geographical coordinate
     @return components of the specified geograhical coordinate (degrees, minutes and seconds)
     */
    extern YMKCoordinateComponents YMKCoordinateComponentsFromMapDegrees(YMKMapDegrees degrees);
    
    /**
     Returns the string representation of coordinate componets (degrees, minutes and seconds).
     @param components coordinate components (degrees, minutes and seconds)
     @return the string representation of the specified coordinate componets
     */
    extern NSString * NSStringFromCoordinateComponents(YMKCoordinateComponents components);
    
#pragma mark - YMKMapRegionSize Consts and Functions
        
    /**
     Used to specify the map region which has a zero size.
     */
    extern YMKMapRegionSize const YMKMapRegionSizeZero;
        
    /**
     Used to specify the region size with invalid parameters.
     */
    extern YMKMapRegionSize const YMKMapRegionSizeInvalid;
    
    /**
     Specifies map region size containing the entire Earth.
     */
    extern YMKMapRegionSize const YMKMapRegionSizeEarth;
    
    /**
     Creates a region of the specified size.
     @param latitudeDelta the difference between latitudes of the most northern and and the most southern points of the region, in degrees. 
     @param longitudeDelta the difference between longitudes of the most western and and the most eastern points of the region, in degrees.
     @return the region of the specified size
     */
    extern YMKMapRegionSize YMKMapRegionSizeMake(YMKMapDegrees latitudeDelta, YMKMapDegrees longitudeDelta);
    
    /**
     Checks if two regions have equal size. 
     @param s1 the size of the first region
     @param s2 the size of the second region
     @return YES - regions have equal size, NO - not
     */
    extern BOOL YMKMapRegionSizeEqualToMapRegionSize(YMKMapRegionSize s1, YMKMapRegionSize s2); 
    
    /**
     Checks if a map region has a zero size.
     @param size the region size
     @return YES - the map region has a zero size, NO - not
     */
    extern BOOL YMKMapRegionSizeIsZero(YMKMapRegionSize size);
    
    /**
     Checks if a map region size is valid.
     @param size the region size
     @return YES - the region size is valid, NO - not
     */
    extern BOOL YMKMapRegionSizeIsValid(YMKMapRegionSize size);
    
    /**
     Converts the map region size to the dictionary.
     @param size the map region size
     @return the dictionary
     */
    extern NSDictionary * NSDictionaryFromMapRegionSize(YMKMapRegionSize size);
    
    /**
     Retrieves the region size from the dictionary.
     The dictionary should contain two keys: latitudeDelta and longitudeDelta which values should be of type double.
     In general, you should use this function only to convert dictionaries that were previously created using the NSDictionaryFromMapRegionSize function.
     @param dict the dictionary
     @return the region size from the dictionary
     */
    extern YMKMapRegionSize YMKMapRegionSizeFromDictionary(NSDictionary * dict);
    
#pragma mark - YMKMapRegion Consts and Functions
        
    /**
     Used to specify the zero-sized region.
     */    
    #define YMKMapRegionZero ((YMKMapRegion){YMKMapCoordinateZero, YMKMapRegionSizeZero})
    
    /**
     Used to specify invalid map region.
     */
    #define YMKMapRegionInvalid ((YMKMapRegion){YMKMapCoordinateInvalid, YMKMapRegionSizeInvalid})
    
    /**
     Specifies map region containing the entire Earth.
     */
    #define YMKMapRegionEarth ((YMKMapRegion){YMKMapCoordinateZero, YMKMapRegionSizeEarth})
    
    /**
     Creates a map region with the specified center and the span measured from its center by latitude and longitude. 
     @param center map coordinates of the region center
     @param span the span measured from the region center by latitude and longitude
     @return the specified region
     */
    extern YMKMapRegion YMKMapRegionMake(YMKMapCoordinate center, YMKMapRegionSize span);
    
    /**
     Checks if two regions are equal.
     @param r1 the first region
     @param r2 the second region
     @returns YES - regions are equal, NO - not
     */
    extern BOOL YMKMapRegionEqualToMapRegion(YMKMapRegion r1, YMKMapRegion r2); 
    
    /**
     Checks if the specified region is zero-sized.
     @param region the map region
     @return YES - the specified region is zero-sized, NO - not
     */
    extern BOOL YMKMapRegionIsZero(YMKMapRegion region);
    
    /**
     Checks if the specified region is valid.
     @param region the region
     @returns YES - the specified region is valid, NO - not
     */
    extern BOOL YMKMapRegionIsValid(YMKMapRegion region);
    
    /**
     Checks if the map region contains the specified geographical coordinate. 
     @param region the map region
     @param ll the geographical coordinate
     @return YES - the region contains the coordinate, NO - not
     */
    extern BOOL YMKMapRegionContainsMapCoordinate(YMKMapRegion region, YMKMapCoordinate ll);
    
    /**
     Checks if the first map region contains the second map region.
     @param r1 the first map region
     @param r2 the second map region
     @return YES - the first region contains the second region, NO - not
     */
    extern BOOL YMKMapRegionContainsMapRegion(YMKMapRegion r1, YMKMapRegion r2);
    
    /**
     Returns the map coordinate of the top left corner of the specified region.
     @param region the region
     @return the map coordinate of the top left corner of the specified region
     */
    extern YMKMapCoordinate YMKMapRegionGetTopLeftCoordinate(YMKMapRegion region);
    
    /**
     Returns the map coordinate of the bottom right corner of the specified region.
     @param region specifies the region
     @return the map coordinate of the bottom right corner of the specified region
     */
    extern YMKMapCoordinate YMKMapRegionGetBottomRightCoordinate(YMKMapRegion region);
    
    /**
     Converts the map region to the dictionary.
     @param region the map region
     @return the dictionary 
     */
    extern NSDictionary * NSDictionaryFromMapRegion(YMKMapRegion region);
    
    /**
     Retrieves the map region from the dictionary.
     In general, you should use this function only to convert dictionaries that were previously created using the NSDictionaryFromMapRegion function.
     @param dict the dictionary
     @return the map region from the dictionary
     */
    extern YMKMapRegion YMKMapRegionFromDictionary(NSDictionary * dict);
    
    /**
     Returns a rectangular area which fits the specified region.
     @param region specifies the region
     @return a rectangular area which fits the specified region
     */
    extern YMKMapRect YMKMapRectFromMapRegion(YMKMapRegion region);
    
#pragma mark - YMKMapRect Consts and Functions
    
    /**
     Used to specify the zero-sized rectangular area.
     */
    #define YMKMapRectZero ((YMKMapRect){YMKMapCoordinateZero, YMKMapCoordinateZero})
    
    /**
     Used to specify rectangular area with invalid parameters.
     */
    #define YMKMapRectInvalid ((YMKMapRect){YMKMapCoordinateInvalid, YMKMapCoordinateInvalid})
    
    /**
     Creates a rectangular map area specified by two coordinates.
     @param firstCoordinate first coordinate
     @param secondCoordinate second coordinate
     @return rectangular map area with correctly calculated top left coordinate and bottom right coordinate
     */
    extern YMKMapRect YMKMapRectMake(YMKMapCoordinate firstCoordinate, YMKMapCoordinate secondCoordinate);
    
    /**
     Checks if two rectangular areas are equal.
     @param r1 the first rectangular area
     @param r2 the second rectangular area
     @return YES - the rectangular areas are equal, NO - not
     */
    extern BOOL YMKMapRectEqualToMapRect(YMKMapRect r1, YMKMapRect r2);
    
    /**
     Checks if the specified rectangular area has zero size.
     @param rect the rectangular area
     @return YES - the specified rectangular area has zero size, NO - not 
     */
    extern BOOL YMKMapRectIsZero(YMKMapRect rect);

    /**
     Checks whether given map rectangle is empty.
     @param rect map rectangle to check
     @return YES if rect has zero width or height. NO otherwise.
     */
    extern BOOL YMKMapRectIsEmpty(YMKMapRect rect);
    
    /**
     Checks if the specified rectangular area is valid.
     @param rect the rectangular area
     @return YES - the specified rectangular area is valid, NO - not
     */
    extern BOOL YMKMapRectIsValid(YMKMapRect rect);
    
    /**
     Checks if the rectangular area contains the specified map coordinate.
     @param rect the rectangular area
     @param ll the geographical coordinate
     @return YES - the rectangular area contains the specified coordinate, NO - not
     */
    extern BOOL YMKMapRectContainsMapCoordinate(YMKMapRect rect, YMKMapCoordinate ll);
    
    /**
     Checks if the first rectangular area contains the second rectangular area.
     @param r1 the first rectangular area
     @param r2 the second rectangular area
     @return YES - the the first rectangular area contains the second rectangular area, NO - not
     */
    extern BOOL YMKMapRectContainsMapRect(YMKMapRect r1, YMKMapRect r2);

    /**
     Expands given map rectangle to include specified coordinate.
     @param rect map rectangle to expand
     @param coordinate coordinate to check
     @return If rect doesn't contain coordinate then it yields expanded rectangle that includes coordinate. 
     Otherwise returns the same rectangle.
     */
    extern YMKMapRect YMKMapRectByAddingCoordinate(YMKMapRect rect, YMKMapCoordinate coordinate);
    
    /**
     Checks if the first rectangular area intersects the second rectangular area.
     @param r1 the first rectangular area
     @param r2 the second rectangular area
     @return YES - the the first rectangular area intersects the second rectangular area, NO - not
     */
    extern BOOL YMKMapRectIntersectsMapRect(YMKMapRect r1, YMKMapRect r2);
    
    /**
     Converts the specified rectangular area to the dictionary
     @param rect the rectangular area
     @return the dictionary
     */
    extern NSDictionary * NSDictionaryFromMapRect(YMKMapRect rect);
    
    /**
     Retrieves the specified rectangular area from the dictionary.
     In general, you should use this function only to convert dictionaries that were previously created using the NSDictionaryFromMapRect function.
     @param dict the dictionary
     @return the rectangular area from the dictionary
     */
    extern YMKMapRect YMKMapRectFromDictionary(NSDictionary * dict);
    
    /**
     Returns the string representation of the rectangular area.
     @param rect the rectangular area
     @return the string representation of the rectangular area
     */
    extern NSString * NSStringFromMapRect(YMKMapRect rect);
    
    /**
     Creates a map rect from string. 
     In general, you should use this function only to convert strings that were previously created using the NSStringFromMapRect function.
     @param string the string
     @return the created coordinate. Returns YMKMapRectInvalid if the receiver is not a valid text representation of a YMKMapRect.
     */
    extern YMKMapRect YMKMapRectFromString(NSString *string);
    
    /**
     Creates a map region from the specified rectangular area.
     @param rect the rectangular area
     @return the map region created from the specified rectangular area
     */
    extern YMKMapRegion YMKMapRegionFromMapRect(YMKMapRect rect);
    
    /**
     Creates a rectangular area with the specified center and the specified vertical and horizontal span measured from its center.
     @param center the center of the rectangular area
     @param meters the vertical and horizontal span measured from the center (in meters)
     @return the rectangular area
     */
    extern YMKMapRect YMKMapRectMakeWithCenterAndMeters(YMKMapCoordinate center, long long int meters);
    
    /**
     Returns coordinate of the reactangular area center.
     @param rect the rectangular area
     @return center coordinate of the rectangular area
     */
    extern YMKMapCoordinate YMKMapRectGetCenterCoordinate(YMKMapRect rect);
    
    /**
     Normalizes the rectangular area if needed. Otherwise returns original rectangular area.
     @param rect the rectangular area to normalize
     @return normalized rectangular area
     */
    extern YMKMapRect YMKMapRectNormalize(const YMKMapRect rect);

    /**
     Calculates rectangular area that bounds all given coordinates.
     Returns YMKMapRectInvalid if given array is nil or empty.
     Returns empty YMKMapRect whose topLeft and bottomRight coordinates point the
     same coordinate if array contains one annotation.
     @param array of YMKMapCoordinate wrapped into NSValue
     @return encasing rectangle for specified coordinates
     */
    extern YMKMapRect YMKMapRectBoundingCoordinates(NSArray *coordinates);

    /**
     Calculates rectangular area that bounds all given annotations. This is just a
     convenience wrapper for YMKMapRectBoundingCoordinates that iterates through specified
     annotations, creates array of NSValues and passes them to YMKMapRectBoundingCoordinates.
     @param array of id<YMKAnnotation>
     @return encasing rectangle for specified annotations
     */
    extern YMKMapRect YMKMapRectBoundingAnnotations(NSArray *annotations);

#pragma mark - YMKMapViewPort Consts and Functions
    
    /**
     Used to specify invalid zoom level.
     */
    #define YMKMapViewZoomLevelInvalid NSUIntegerMax
    
    /**
     Used to specity zero-sized viewport.
     */
    #define YMKMapViewPortZero ((YMKMapViewPort){YMKMapRectZero, 0})
    
    /**
     Used to specity invalid viewport.
     */
    #define YMKMapViewPortInvalid ((YMKMapViewPort){YMKMapRectInvalid, YMKMapViewZoomLevelInvalid})
    
    /**
     Creates view port with given rect and zoom level
     @param rect the rectangular area
     @param zoomLevel map zoom level
     @return map view port
     */
    extern YMKMapViewPort YMKMapViewPortMake(YMKMapRect rect, NSUInteger zoomLevel);
    
    /**
     Checks if the first map view port contains the second view port.
     @param viewPort the first map view port
     @param subViewPort the second map view port
     @return YES - the the first view port contains the second view port, NO - not
     */
    extern BOOL YMKMapViewPortContainsViewPort(YMKMapViewPort viewPort, YMKMapViewPort subViewPort); 
    
    /**
     Checks if the first map view port is equal to the second view port.
     @param a the first map view port
     @param b the second map view port
     @return YES if the first view port is equal to the second view port, otherwise NO
     */
    extern BOOL YMKMapViewPortEqualToViewPort(YMKMapViewPort a, YMKMapViewPort b);
    
    /**
     Checks if the map view port is zero map view port.
     @param rect the map view port
     @return YES if the map view port is zero map view port, otherwise NO
     */
    extern BOOL YMKMapViewPortIsZero(YMKMapViewPort rect);
    
    /**
     Checks if the map view port is valid map view port.
     @param rect the map view port
     @return YES if the map view port is valid map view port, otherwise NO
     */
    extern BOOL YMKMapViewPortIsValid(YMKMapViewPort viewPort);
    
    /**
     Returns the string representation of the map view port.
     @param viewPort the map view port
     @return the string representation of the map view port. 
     */
    extern NSString * NSStringFromMapViewPort(YMKMapViewPort viewPort);
    
    /**
     Creates a map view port from string. 
     In general, you should use this function only to convert strings that were previously created using the NSStringFromMapViewPort function.
     @param string the string
     @return the created coordinate. Returns YMKMapViewPortZero if the receiver is not a valid text representation of a YMKMapViewPort.
     */
    extern YMKMapViewPort YMKMapViewPortFromString(NSString *string);
    
    /**
     Converts the specified view port to the dictionary
     @param viewPort the view port
     @return the dictionary
     */
    extern NSDictionary * NSDictionaryFromMapViewPort(YMKMapViewPort viewPort);
    
    /**
     Retrieves the specified view port from the dictionary.
     In general, you should use this function only to convert dictionaries that were previously created using the NSDictionaryFromMapViewPort function.
     @param dict the dictionary
     @return the view port from the dictionary
     */
    extern YMKMapViewPort YMKMapViewPortFromDictionary(NSDictionary * dict);
    
#ifdef __cplusplus
}
#endif
