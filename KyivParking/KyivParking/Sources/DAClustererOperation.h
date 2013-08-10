//
//  DAClustererOperation.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/24/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAFetchRequestOperation.h"


@interface DAClustererOperation : DAFetchRequestOperation

- (id)initWithContext:(NSManagedObjectContext *)context request:(NSFetchRequest *)request
	region:(YMKMapRegion)region;

@end
