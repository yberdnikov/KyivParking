/*
 * YMKAnnotationImage.h
 *
 * This file is a part of the Yandex Map Kit.
 *
 * Version for iOS © 2010-2012 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.ru/mapkit/
 */

#import <Foundation/Foundation.h>

/**
 This class is container of data for appearance customisation of annotation when you use YMMapImageBuilder.
 */
@interface YMKAnnotationImage : NSObject

/** @name Creating Annotation Image */

/**
 @abstract Creates and returns a newly created instance with the given parameters.
 @discussion An YMKAnnotationImage class is used in conjuction with YMMapImageBuilder class to provide the ability
 to render static map screenshots.
 @param image Image for the default (not highlighted) state.
 @param highlightedImage Image for the highlighted state. May be nil.
 @param centerOffset Center offset that must be applied to the image.
 @return An YMKAnnotationImage instance configured with the given center offset and the images.
 @see YMMapImageBuilder.
 */
+ (instancetype)annotationImageWithImage:(UIImage *)image
                        highlightedImage:(UIImage *)highlightedImage
                            centerOffset:(CGPoint)centerOffset;

/**
 @abstract Creates and returns a newly created instance with the given parameters.
 @discussion An YMKAnnotationImage class is used in conjuction with YMMapImageBuilder class to provide the ability
 to render static map screenshots.
 @param image Image for the default (not highlighted) state.
 @param centerOffset Center offset that must be applied to the image.
 @return An YMKAnnotationImage instance configured with the given center offset and the images.
 @see YMMapImageBuilder.
 */
+ (instancetype)annotationImageWithImage:(UIImage *)image
                            centerOffset:(CGPoint)centerOffset;

/**
 @abstract Designated initializer. Initializes a new annotation mage.
 @param image Image for normal state.
 @param highlightedImage Image for highlighted state.
 @param centerOffset Offset (in points) to the center of the image.
 */
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                 centerOffset:(CGPoint)centerOffset;

/** @name Default Annotation Image Instances */

/**
 Instancinates and returns an annotation image configured to display blue pin.
 @return An annotation image with the blue pin.
 */
+ (instancetype)blueAnnotationImage;

/**
 Instancinates and returns an annotation image configured to display green pin.
 @return An annotation image with the green pin.
 */
+ (instancetype)greenAnnotationImage;

/** @name Appearance */

/**
 The offset (in points) relative to the annotation image center.
 */
@property (nonatomic, assign) CGPoint centerOffset;

/**
 The image for display.
 */
@property (nonatomic, retain) UIImage *image;

/**
 The image for the highlighted state.
 */
@property (nonatomic, retain) UIImage *highlightedImage;

@end
