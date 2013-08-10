//
//  DAClusterAnnotationView.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/25/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAClusterAnnotationView.h"

#import <QuartzCore/QuartzCore.h>

#import "DACluster.h"
#import "DAUtilities.h"


static const CGFloat kDAMaxClusterDiameter = 60.0f;
static const CGFloat kDAMinClusterDiameter = 40.0f;


static const CGFloat kDAMinFontSize = 15.0f;
static const CGFloat kDAMidFontSize = 16.0f;
static const CGFloat kDAMaxFontSize = 17.0f;

// Range diameter < kDAMinClusterDiameter + diff for font size:
static const CGFloat kDAMinFontClusterDiameterDiff = 5.0f;
static const CGFloat kDAMidFontClusterDiameterDiff = 15.0f;


@interface DACircleLayer : CALayer

@property (nonatomic, assign) CGFloat angle;

@end


@interface DAClusterAnnotationView ()

- (NSAttributedString *)attributedStringForCount:(NSUInteger)count diameter:(CGFloat)diameter;
- (CABasicAnimation *)angleAnimation;

@end


@implementation DAClusterAnnotationView {
	DACircleLayer *_circleLayer;
	CATextLayer *_textLayer;
	CABasicAnimation *_angleAnimation;
}

@dynamic annotation;


- (id)initWithAnnotation:(NSObject<YMKAnnotation> *)annotation
		 reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

	if (nil != self) {
		_circleLayer = [DACircleLayer new];
		_circleLayer.needsDisplayOnBoundsChange = YES;
		[self.layer addSublayer:_circleLayer];
		
		_textLayer = [CATextLayer new];
		_textLayer.needsDisplayOnBoundsChange = YES;
		[self.layer addSublayer:_textLayer];
	}

	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
}

- (void)setFrame:(CGRect)frame
{
	CGFloat diameter = self.max > 0
		? ceilf( (CGFloat) [[self.annotation locations] count] / (CGFloat) self.max * 100.0f )
		: 0.0f;
	diameter = MAX(kDAMinClusterDiameter, MIN(kDAMaxClusterDiameter, diameter));

	CGRect rect = CGRectMake(
		ceilf(CGRectGetMidX(frame) - diameter / 2),
		ceilf(CGRectGetMidY(frame) - diameter / 2),
		diameter, diameter);

	if (!CGRectEqualToRect(rect, self.frame)) {
		[super setFrame:rect];

		_circleLayer.frame = self.bounds;

		_textLayer.string = [self attributedStringForCount:[[self.annotation locations] count] diameter:diameter];

		CGRect textFrame = CGRectZero;
		textFrame.size = [_textLayer.string size];
		textFrame.origin = CGPointMake(CGRectGetMidX(self.bounds) - CGRectGetWidth(textFrame) / 2,
			CGRectGetMidY(self.bounds) - CGRectGetHeight(textFrame) / 2);
		_textLayer.frame = textFrame;

		//[_circleLayer addAnimation:[self angleAnimation] forKey:@"angle"];
	}
}

- (void)setAnnotation:(DACluster *)annotation
{
	[super setAnnotation:annotation];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if (flag) {
		_circleLayer.angle = DEGREES_TO_RADIANS(360.0f);
	}
}

#pragma mark - Private

- (CABasicAnimation *)angleAnimation
{
	if (nil == _angleAnimation) {
		_angleAnimation = [CABasicAnimation animationWithKeyPath:@"angle"];
		_angleAnimation.fromValue = @0.0f;
		_angleAnimation.toValue = @DEGREES_TO_RADIANS(360.0f);
		_angleAnimation.duration = RANDOM_IN_RANGE(1.0, 0.7);
		_angleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		_angleAnimation.delegate = self;
	}

	return _angleAnimation;
}

- (NSAttributedString *)attributedStringForCount:(NSUInteger)count diameter:(CGFloat)diameter
{
	NSString *string = [NSString stringWithFormat:@"%u", count];
	
	CGFloat fontSize = kDAMaxFontSize;

	if (diameter < kDAMinClusterDiameter + kDAMinFontClusterDiameterDiff) {
		fontSize = kDAMinFontSize;
	}
	else if (diameter < kDAMinClusterDiameter + kDAMidFontClusterDiameterDiff) {
		fontSize = kDAMidFontSize;
	}
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string
		attributes:@{
			NSForegroundColorAttributeName : (id)[UIColor whiteColor].CGColor,
			NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]
		}];

	return attributedString;
}

@end


@implementation DACircleLayer

+ (BOOL)needsDisplayForKey:(NSString *)key
{
	return [key isEqualToString:@"angle"] || [super needsDisplayForKey:key];
}

- (id)initWithLayer:(id)layer
{
	self = [super initWithLayer:layer];

	if (nil != self) {
		if ([layer isKindOfClass:[DACircleLayer class]]) {
			self.angle = ((DACircleLayer *)layer).angle;
		}
	}

	return self;
}

- (void)setAngle:(CGFloat)angle
{
	[self willChangeValueForKey:@"angle"];
	_angle = angle;
	[self setNeedsDisplay];
	[self didChangeValueForKey:@"angle"];
}

- (void)drawInContext:(CGContextRef)ctx
{
	if (NULL == ctx) {
		return;
	}

	static const CGFloat kDALineWidth = 4.0f;

	CGContextSetFillColorWithColor(ctx, [UIColor darkGrayColor].CGColor);
	CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);

	CGRect rect = self.frame;
	CGContextFillEllipseInRect(ctx, rect);

	rect = CGRectInset(self.frame, kDALineWidth / 2, kDALineWidth / 2);
	CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGPoint start = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
	CGFloat radius = CGRectGetWidth(rect) / 2;

	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, start.x, start.y);
	CGPathAddArc(path, NULL, center.x, center.y, radius, 0.0f, self.angle, false);
	CGContextAddPath(ctx, path);
	CGContextSetLineWidth(ctx, kDALineWidth);
	CGContextStrokePath(ctx);
	CGPathRelease(path);
}

@end
