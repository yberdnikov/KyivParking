//
//  DACalloutView.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/13/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DACalloutView.h"
#import "DACalloutContentView.h"


static const CGSize kDACalloutViewMinBoundarySize = { 180.0f, 127.0f };
static const CGSize kDACalloutViewFixedBoundarySize = { 32.0f, 106.0f }; // Boundary size excluding address label size. Width is equal to offsets from left and right. Height is sum of controls heights, inner and outher offsets.


@implementation DACalloutView

- (void)setAnchorPoint:(CGPoint)point boundaryRect:(CGRect)rect
{
	DACalloutContentView *contentView = (DACalloutContentView *)self.contentView;

	CGSize addressSize = [contentView.addressLabel.text sizeWithFont:contentView.addressLabel.font
		constrainedToSize:CGSizeMake(CGRectGetWidth(contentView.addressLabel.bounds), MAXFLOAT)
		lineBreakMode:contentView.addressLabel.lineBreakMode];
	CGSize tariffSize = [contentView.tariffLabel.text sizeWithFont:contentView.tariffLabel.font
		constrainedToSize:CGSizeMake(CGRectGetWidth(contentView.tariffLabel.bounds), MAXFLOAT)
		lineBreakMode:contentView.tariffLabel.lineBreakMode];

	CGRect boundaryRect = rect;
	boundaryRect.size.width = MAX(kDACalloutViewMinBoundarySize.width,
		MAX(addressSize.width, tariffSize.width) + kDACalloutViewFixedBoundarySize.width);
	boundaryRect.size.height = MAX(kDACalloutViewMinBoundarySize.height,
		addressSize.height + kDACalloutViewFixedBoundarySize.height);

	[super setAnchorPoint:point boundaryRect:boundaryRect];
}

- (BOOL)highlighted
{
	return NO;
}

@end
