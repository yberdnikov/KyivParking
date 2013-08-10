//
//  DAParkingViewController.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/31/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAParkingViewController.h"
#import "DAParking.h"
#import "DATariffZoneFormatter.h"


@interface DAParkingViewController () <YMKMapImageBuilderDelegate>

@property (nonatomic, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, weak) IBOutlet UILabel *tariffLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (IBAction)showMap:(id)sender;
- (IBAction)parkHere:(id)sender;

- (void)reloadData;

@end


@implementation DAParkingViewController {
	YMKMapImageBuilder *_imageBuilder;
	DATariffZoneFormatter *_tariffZoneFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	_tariffZoneFormatter = [DATariffZoneFormatter new];

	[self reloadData];
}

- (void)setParking:(DAParking *)parking
{
	if (parking != _parking) {
		[self willChangeValueForKey:@"parking"];
		_parking = parking;
		[self didChangeValueForKey:@"parking"];
		[self reloadData];
	}
}

#pragma mark - YMKMapImageBuilderDelegate

- (YMKAnnotationImage *)mapImageBuilder:(YMKMapImageBuilder *)builder
	annotationImageForAnnotation:(id<YMKAnnotation>)annotation
{
	NSString *imageName = [NSString stringWithFormat:@"TariffZone%@Balloon", self.parking.area];
	UIImage *image = [UIImage imageNamed:imageName];
	image = nil != image ? image : [UIImage imageNamed:@"TariffZoneUnknownBalloon"];

	return [YMKAnnotationImage annotationImageWithImage:image centerOffset:CGPointZero];
}

- (void)mapImageBuilder:(YMKMapImageBuilder *)builder builtImage:(UIImage *)image
{
	self.imageView.image = image;
}

- (void)mapImageBuilderFailedToLoadCompleteImage:(YMKMapImageBuilder *)builder partialImage:(UIImage *)image
{
}

#pragma mark - Private

- (IBAction)showMap:(id)sender
{
	[self.delegate parkingViewControllerShouldShowMap:self];
}

- (IBAction)parkHere:(id)sender
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)reloadData
{
	if ([self isViewLoaded]) {
		if (nil != self.parking) {
			self.navigationItem.title = self.parking.address;
			self.addressLabel.text = self.parking.address;
			self.tariffLabel.text = [_tariffZoneFormatter stringFromParking:self.parking];
			self.distanceLabel.text = [NSString stringWithFormat:@"%.2f km", self.parking.distance / 1000.0];

			static const CGSize kDAImageSize = { 280.0f, 280.0f };

			[_imageBuilder cancel];
			_imageBuilder = [[YMKMapImageBuilder alloc] initWithAnnotation:self.parking];
			_imageBuilder.delegate = self;
			_imageBuilder.centerCoordinate
				= YMKMapCoordinateMake(self.parking.latitude, self.parking.longitude);
			_imageBuilder.imageSize = kDAImageSize;
			[_imageBuilder build];
		}
		else {
			self.imageView.image = nil;
			self.addressLabel.text = @"";
			self.tariffLabel.text = @"";
			self.distanceLabel.text = @"";
		}
	}
}

@end
