/*
 * YMKDefaultCalloutView.h
 *
 * This file is a part of the Yandex Map Kit.
 *
 * Version for iOS © 2011-2013 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.ru/mapkit/
 */

#import "YMKCalloutView.h"


/**
 @abstract A default callout view with a title and a subtitle.
 */
@interface YMKDefaultCalloutView : YMKCalloutView

/**
 @abstract An annotation to source the title and the subtitle from.
 */
@property (nonatomic, strong) id<YMKAnnotation> annotation;

@end
