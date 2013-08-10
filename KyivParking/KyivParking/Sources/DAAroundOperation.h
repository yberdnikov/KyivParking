//
//  DAAroundOperation.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/30/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAFetchRequestOperation.h"


@interface DAAroundOperation : DAFetchRequestOperation

- (id)initWithContext:(NSManagedObjectContext *)context request:(NSFetchRequest *)request
	location:(CLLocation *)location radius:(CLLocationDistance)radius;

@end
