/*
 * YMKCalloutView.h
 *
 * This file is a part of the Yandex Map Kit.
 *
 * Version for iOS © 2011-2012 YANDEX
 * 
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.ru/mapkit/
 */

#import <UIKit/UIKit.h>
#import "YMKCalloutContentView-Protocol.h"

@class YMKAnnotationView;
@class YMKCalloutView;
@protocol YMKAnnotation;

@protocol YMKCalloutViewDelegate <NSObject>
@optional

/**
 Called when callout view receives a tap.
 @param view Callout view that received a tap gesture.
 */
- (void)calloutViewGotSingleTap:(YMKCalloutView*)view;

/**
 Called when callout view receives a tap on left accessory view.
 @param view Callout view that received a tap gesture on left accessory view.
 */
- (void)calloutViewGotTapAtLeftAccessoryView:(YMKCalloutView*)view;

/**
 Called when callout view receives a tap on right accessory view.
 @param view Callout view that received a tap gesture on right accessory view.
 */
- (void)calloutViewGotTapAtRightAccessoryView:(YMKCalloutView*)view;

@end

/**
 Base class for callouts. View hierarchy describes the following figure:
 
     +--------------------------------+
     | +------+ +---------+           |
     | | left | |         | +-------+ |
     | | view | | content | | right | |
     | +------+ |  view   | | view  | |
     |          |         | +-------+ |
     |          +---------+           |
     +--------------   ---------------+
                    \ /
                     +
                    anchor point
 */
@interface YMKCalloutView : UIView

/** @name Creating Callout Views */

/**
 @abstract Initializes instance with the given reuse identifier.
 @discussion Callout views, like annotation views, may be reused to minimize memory usage.
 To obtain an instance ready to be reused with the given identifier you would use
 [YMKMapView dequeueReusableCalloutViewWithIdentifier:] method.
 @param reuseIdentifier Reuse Identifier.
 @return Instance initialized with the given reuse identifier.
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 Delegate receives notifications about gestures that user may perform with callout's content.
 */
@property (nonatomic, assign) id<YMKCalloutViewDelegate> delegate;

/** @name Callout Content */

/**
 Left accessory view displayed at left part of the callout.
 */
@property (nonatomic, retain) UIView *leftView;

/**
 Sets left accessory view.
 @param leftView A view that will be set as left accessory view.
 @param animated Should the update be animated or not.
 */
- (void)setLeftView:(UIView *)leftView animated:(BOOL)animated;

/**
 Right accessory view displayed at right part of the callout.
 */
@property (nonatomic, retain) UIView *rightView;

/**
 Sets right accessory view.
 @param rightView A view that will be set as right accessory view.
 @param animated Should the update be animated or not.
 */
- (void)setRightView:(UIView *)rightView animated:(BOOL)animated;

/**
 Content view of the callout. View must conform to YMKCalloutContentView protocol.
 */
@property (nonatomic, retain) UIView<YMKCalloutContentView> *contentView;

/** @name Appearance */

/**
 Returns YES if callout processing touch event and it's content is highlighted; NO otherwise.
 */
@property (nonatomic, assign, readonly) BOOL highlighted;

/**
 Returns YES if callout is hidden; NO otherwise.
 */
@property (nonatomic, assign, readonly, getter=isHidden) BOOL hidden;

/**
 @abstract Provides default disclosure indicator view for the callout.
 @discussion An accessory control shaped like a regular chevron. It is intended as a disclosure indicator.
 The control doesn't track touches.
 @return UIView that you would set to rightView property.
 */
+ (UIView *)defaultDisclosureIndicatorView;

/**
 @abstract Sets the anchor point of the callout view in the given boundary rect.
 @discussion This method is called automatically by annotation view when it displays receiver.
 You should not call this method directly.
 @param point Anchor point
 @param rect Boundary Rect of the callout
 */
- (void)setAnchorPoint:(CGPoint)point boundaryRect:(CGRect)rect;

/**
 Removes callout from screen.
 */
- (void)hide;

/** @name Reusing Callout Views */

/**
 Reuse identifier callout view was created with.
 */
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

/**
 @abstract Called when the receiver is removed from the reuse queue.
 @discussion You can override it in your custom subclass and use it to put the receiver in a known state before it is reused.
 You must call 'super' if you override this method.
 */
- (void)prepareForReuse;

/** @name Other */

/**
 @abstract Attaches receiver to the annotation view.
 @discussion This method is called automatically by annotation view instance when it displays callout view.
 You should not call this method directly.
 @param annotationView Annotation view on top of which callout view should be displayed.
 */
- (void)showAtAnnotationView:(YMKAnnotationView *)annotationView;

/**
 @abstract Attaches receiver to the annotation view.
 @discussion This method is called automatically by annotation view instance when it displays callout view.
 You should not call this method directly.
 @param annotationView Annotation view on top of which callout view should be displayed.
 @param animated Should animate or not.
 */
- (void)showAtAnnotationView:(YMKAnnotationView *)annotationView animated:(BOOL)animated;

/**
 @abstract Calculate callout size.
 */
- (CGSize)sizeWithContentView:(UIView *)contentView
					 leftView:(UIView *)leftView
					rightView:(UIView *)rightView
				 boundaryRect:(CGRect)rect;

@end
