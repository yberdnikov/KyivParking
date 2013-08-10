/*
 * YMKAnnotationView.h
 *
 * This file is a part of the Yandex Map Kit.
 *
 * Version for iOS © 2011-2012 YANDEX
 * 
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.ru/mapkit/
 */

#import <Foundation/Foundation.h>
#import "YMKAnnotation.h"

/**
 Visually presents annotations on the map.
 @see http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MKAnnotationView_Class/Reference/Reference.html
 */

@class YMKCalloutView;

@interface YMKAnnotationView : UIView

/**
 The string identifier which allows to reuse the annotation view.
 */
@property (nonatomic, readonly) NSString *reuseIdentifier;

/**
 The annotation object associated with the annotation view.
 */
@property (nonatomic, retain) NSObject<YMKAnnotation> *annotation;

/**
 The offset (in points) relative to the coordinate point of the annotation.
 */
@property (nonatomic) CGPoint centerOffset;

/**
 Specifies if the annotation view is currently selected.
 */
@property (nonatomic, getter=isSelected) BOOL selected;

/**
 The image displayed in the annotation view.
 */
@property (nonatomic, retain) UIImage *image;

/**
 @abstract The image displayed in the annotation view when it's in selected state.
 @discussion The selected image must be the same size as the not selected image. 
 Moreover, their center offsets are intended to be equal too.
 */
@property (nonatomic, strong) UIImage *selectedImage;

/**
 Specifies if the content of the annotation view should be centrally aligned.
 */
@property (nonatomic, assign) BOOL alignCenter;

/**
 zIndex of the annotation view. The object with the highest zIndex is displayed
 uppermost on the map.
 */
@property (nonatomic, assign) NSInteger zIndex;

/**
 Specifies if the annotation view is able to display a callout balloon.
 */
@property (nonatomic, assign) BOOL canShowCallout;

/**
 The offset of the callout (in points) relative to the top center point of the annotation view.
 */
@property (nonatomic, assign) CGPoint calloutOffset;

/**
 The original size of the frame annotation view (in pixels).
 */
@property (nonatomic, readonly) UIEdgeInsets minimumMargins;

/**
 The callout view if shown.
 */
@property (nonatomic, readonly) YMKCalloutView *visibleCalloutView;

/**
 Designated initializer. Initializes a new annotation view.
 @param annotation the annotation object associated with the view
 @param reuseIdentifier the identifier you need to reuse the view
 @return a new annotation view
 */
- (id)initWithAnnotation:(NSObject<YMKAnnotation> *)annotation
		 reuseIdentifier:(NSString *)reuseIdentifier;

/**
 Called when the annotation view is removed from the reuse queue.
 */
- (void)prepareForReuse;

/**
 Specifies if the view should be displayed selected.
 @param selected YES - the view is displayed selected, NO - not
 @param animated YES - selecting/deselecting the view should be animated, NO - not
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;



@end
