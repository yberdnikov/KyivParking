//
//  DATariffZoneFormatter.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/30/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DATariffZoneFormatter.h"
#import "DAParking.h"


@implementation DATariffZoneFormatter {
	NSDictionary *_tariffs;
}

- (id)init
{
	self = [super init];

	if (nil != self) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"Tariffs" ofType:@"plist"];
		_tariffs = [[NSDictionary alloc] initWithContentsOfFile:path];
	}

	return self;
}

- (NSString *)stringFromParking:(DAParking *)parking
{
	NSString *result = nil;

	if (nil != parking.area) {
		NSNumber *tariff = _tariffs[parking.area];

		if (nil != tariff) {
			result = [NSString stringWithFormat:NSLocalizedString(@"UAHPerHourFormat", nil),
				parking.area, _tariffs[parking.area]];
		}
		else {
			result = NSLocalizedString(@"UnknownTariffZone", nil);
		}
	}

	return result;
}

@end
