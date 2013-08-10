/*
 * YMKMapImageBuilder.h
 *
 * This file is a part of the Yandex Map Kit.
 *
 * Version for iOS © 2010-2012 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.ru/mapkit/
 */

#import <Foundation/Foundation.h>
#import "YMKMapStructs.h"

@class YMKMapImageBuilder;
@class YMKAnnotationImage;
@protocol YMKAnnotation;

@protocol YMKMapImageBuilderDelegate<NSObject>
@optional

/**
 @abstract Provides an YMKAnnotationImage instance used to render annotation.
 @param builder Object that performs rendering.
 @param annotation Annotation that is being drawn.
 @return YMKAnnotationImage instance used to render the given annotation.
 */
- (YMKAnnotationImage *)mapImageBuilder:(YMKMapImageBuilder *)builder annotationImageForAnnotation:(id<YMKAnnotation>)annotation;

/**
 @abstract Called when rendering completes.
 @param builder Object that finished rendering.
 @param image Resulting image.
 */
- (void)mapImageBuilder:(YMKMapImageBuilder *)builder builtImage:(UIImage *)image;

/**
 @abstract Called when rendering fails.
 @param builder Object that failed to render.
 @param image Partial image. May be nil.
 */
- (void)mapImageBuilderFailedToLoadCompleteImage:(YMKMapImageBuilder *)builder partialImage:(UIImage *)image;

/**
 @abstract Called when rendering cancels.
 @param builder Object that cancelled rendering.
 */
- (void)mapImageBuilderWasCancelled:(YMKMapImageBuilder *)builder;

@end

/**
 This class allows you to render static map images. These images can display annotations.
 */
@interface YMKMapImageBuilder : NSObject

/**
 @abstract Instance delegate.
 @discussion If you render annotations on the map, you should implement mapImageBuilder:annotationImageForAnnotation: 
 delegate method.
 */
@property(nonatomic, assign) id<YMKMapImageBuilderDelegate> delegate;

/** @name Map Configuration */

/**
 Map center coordinate.
 */
@property(nonatomic, assign) YMKMapCoordinate centerCoordinate;

/**
 @abstract Offset in points that is applied to the centerCoordinate.
 @discussion You would specify this offset if you'd like to shift map somehow.
 */
@property(nonatomic, assign) CGPoint centerOffset;

/**
 Zoom level of the map.
 */
@property(nonatomic, assign) NSUInteger zoomLevel;

/**
 @abstract Identifier of the layer which should be rendered.
 @discussion Different layers provide different map types. E.g. schema, satellite, people map, etc.
 You can obtain layer identifier from [YMKMapLayerInfo identifier] object, which is accessible from 
 [YMKConfiguration mapLayers].
 */
@property(nonatomic, assign) uint16_t layerIdentifier;

/** @name Appearance configuration */

/**
 Size of the resulting image.
 */
@property(nonatomic, assign) CGSize imageSize;

/**
 Fill color for the areas of the map where tiles can't be obtained.
 */
@property(nonatomic, retain) UIColor *failedImageBgColor;

/** @name Annotations */

/**
 Annotations that should be displayed on the rendered map image.
 */
@property(nonatomic, copy) NSArray *annotations;

/** @name Creating new builder object */

/**
 @abstract Initializes new builder object.
 */
- (instancetype)init;

/**
 @abstract Initializes new builder object to render the given annotation.
 @param annotation An annotation that should be rendered.
 */
- (instancetype)initWithAnnotation:(id<YMKAnnotation>)annotation;

/**
 @abstract Initializes new builder object to render the given array of the annotations.
 @discussion Each object in the array must conform to YMKAnnotation protocol.
 @param annotations Array of the annotations.
 */
- (instancetype)initWithAnnotations:(NSArray *)annotations;

/** @name Workflow */

/**
 @abstract Initiates a build process.
 @discussion Build process is asynchronous. You must setup builder instance before calling this method.
 */
- (void)build;

/**
 Cancels previously started build map image process
 */
- (void)cancel;

@end
