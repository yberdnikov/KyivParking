//
//  DAClusterAnnotationView.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/25/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DACluster.h"


@interface DAClusterAnnotationView : YMKAnnotationView

@property (nonatomic, strong) DACluster *annotation;

@property (nonatomic, assign) NSUInteger max; // Current max number of objects in cluster upon all visible clusters

@end
