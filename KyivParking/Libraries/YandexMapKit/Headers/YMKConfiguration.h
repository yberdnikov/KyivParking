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

@class YMKMapLayersConfiguration;

/**
 Yandex Map Kit configuration object allows you to query available map layers and provide your API key.
 You should use shared instance to perform configuration.
 */
@interface YMKConfiguration : NSObject

/**
 Available map layers. Observable with KVO.
 */
@property (nonatomic, retain, readonly) YMKMapLayersConfiguration *mapLayers;

/**
 Your API key. You should set API key as early as possible.
 */
@property (nonatomic, copy) NSString *apiKey;

/**
 Returns shared instance you would use to work with.
 */
+ (YMKConfiguration *)sharedInstance;

@end
