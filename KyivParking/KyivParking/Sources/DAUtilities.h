//
//  DAUtilities.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/26/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


#define RANDOM_IN_RANGE(max, min) ((__typeof__(max)) rand() / RAND_MAX * ((max) - (min)) + (min))

#define EUCLIDEAN_DISTANCE(A, B) ( sqrt( ((A).latitude - (B).latitude) * ( (A).latitude - (B).latitude) \
									+ ((A).longitude - (B).longitude) * ((A).longitude - (B).longitude)) )

#define DEGREES_TO_RADIANS(degrees) ((degrees) * M_PI / 180.0f);


extern const double kDAComparisonDelta;
