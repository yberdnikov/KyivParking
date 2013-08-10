//
//  DATariffZoneFormatter.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/30/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


@class DAParking;


@interface DATariffZoneFormatter : NSObject

- (NSString *)stringFromParking:(DAParking *)parking;

@end
