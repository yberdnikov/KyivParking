//
//  DAMapViewController.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/11/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAMapViewController.h"

#import <MessageUI/MessageUI.h>

#import "DAAppDelegate.h"
#import "DADataController.h"
#import "DAParking.h"
#import "DACluster.h"
#import "DATariffZoneFormatter.h"
#import "DACalloutContentView.h"
#import "DACalloutView.h"
#import "DAClusterAnnotationView.h"
#import "DAListViewController.h"


static const YMKMapCoordinate kDAKyivCoordinates = { 50.45, 30.52333 };

static const NSUInteger kDADefaultZoomLevel = 8;
static const NSUInteger kDAMaxVisibelObjects = 40;

static NSString * const kDAListSequeIdentifier = @"ListSeque";


@interface DAMapViewController () <YMKMapViewDelegate, DAListViewControllerDelegate>

@property (nonatomic, weak) IBOutlet YMKMapView *mapView;

- (void)updateVisibleParkings;
- (void)updateVisibleClusters;
- (void)replaceAnnotations:(NSArray *)annotationsToReplace withAnnotations:(NSArray *)newAnnotations;

- (IBAction)showKyiv:(id)sender;
- (IBAction)parkHere:(id)sender;

@end


@implementation DAMapViewController {
	DATariffZoneFormatter *_tariffZoneFormatter;
	YMKMapRegion _previousRegion;
	NSUInteger _largestCluster; // Number of elements in the largest cluster
	BOOL _clustersVisible;
	__weak DAListViewController *_listViewController; // List view controller if presented
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.mapView.showsUserLocation = YES;
	self.mapView.showTraffic = NO;

	_tariffZoneFormatter = [DATariffZoneFormatter new];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (0 == [[DADataController sharedDataController] numberOfParkingsForRegion:YMKMapRegionEarth]) {
		NSURL *url = [[NSBundle mainBundle] URLForResource:@"Parkings-Test-10000" withExtension:@"xml"];

		[[DADataController sharedDataController] importDataFromFileAtURL:url completion:^{
			[self updateVisibleParkings];
		}];
	}

	static BOOL once = YES;
	if (once) {
		[self.mapView setCenterCoordinate:kDAKyivCoordinates atZoomLevel:kDADefaultZoomLevel
			animated:animated];
		once = NO;
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kDAListSequeIdentifier]) {
		UINavigationController *navigationViewController = segue.destinationViewController;
		_listViewController = (DAListViewController *)navigationViewController.topViewController;
		_listViewController.delegate = self;
		_listViewController.userLocation = self.mapView.userLocation;
	}
}

#pragma mark - YMKMapViewDelegate

- (YMKAnnotationView *)mapView:(YMKMapView *)mapView viewForAnnotation:(id<YMKAnnotation>)annotation
{
	YMKAnnotationView *annotationView = nil;

	static NSString * const kDAParkingAnnotationViewReuseIdentifier = @"ParkingAnnotationView";
	static NSString * const kDAClusterAnnotationViewReuseIdentifier = @"ClusterAnnotationView";

	if ([annotation isKindOfClass:[DAParking class]]) {
		annotationView = [mapView
			dequeueReusableAnnotationViewWithIdentifier:kDAParkingAnnotationViewReuseIdentifier];

		if (nil == annotationView) {
			annotationView = [[YMKAnnotationView alloc] initWithAnnotation:annotation
				reuseIdentifier:kDAParkingAnnotationViewReuseIdentifier];
			annotationView.canShowCallout = YES;
		}

		annotationView.annotation = annotation;

		DAParking *parking = annotation;
		NSString *imageName = [NSString stringWithFormat:@"TariffZone%@Balloon", parking.area];
		NSString *selectedImageName = [NSString stringWithFormat:@"TariffZone%@BalloonSelected", parking.area];
		UIImage *image = [UIImage imageNamed:imageName];
		UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
		annotationView.image = nil != image ? image : [UIImage imageNamed:@"TariffZoneUnknownBalloon"];
		annotationView.selectedImage = nil != selectedImage ? selectedImage : [UIImage imageNamed:@"TariffZoneUnknownBalloonSelected"];
	}
	else {
		annotationView = [mapView
			dequeueReusableAnnotationViewWithIdentifier:kDAClusterAnnotationViewReuseIdentifier];

		if (nil == annotationView) {
			annotationView = [[DAClusterAnnotationView alloc] initWithAnnotation:annotation
				reuseIdentifier:kDAClusterAnnotationViewReuseIdentifier];
			annotationView.canShowCallout = NO;
		}

		annotationView.annotation = annotation;
		((DAClusterAnnotationView *)annotationView).max = _largestCluster;
	}

	return annotationView;
}

- (YMKCalloutView *)mapView:(YMKMapView *)view calloutViewForAnnotation:(id<YMKAnnotation>)annotation
{
	static NSString * const kDAParkingCalloutViewReuseIdentifier = @"ParkingCalloutView";

	YMKCalloutView *calloutView = [view
		dequeueReusableCalloutViewWithIdentifier:kDAParkingCalloutViewReuseIdentifier];

	if (nil == calloutView) {
		calloutView = [[DACalloutView alloc] initWithReuseIdentifier:kDAParkingCalloutViewReuseIdentifier];

		UINib *nib = [UINib nibWithNibName:@"DACalloutContentView" bundle:[NSBundle mainBundle]];
		NSArray *topLevelObjects = [nib instantiateWithOwner:self options:nil];

		if ([topLevelObjects count] > 0) {
			DACalloutContentView *contentView = topLevelObjects[0];
			calloutView.contentView = contentView;
		}
	}

	DAParking *parking = annotation;

	DACalloutContentView *contentView = (DACalloutContentView *)calloutView.contentView;
	contentView.addressLabel.text = parking.address;
	contentView.tariffLabel.text = [_tariffZoneFormatter stringFromParking:parking];

	return calloutView;
}

- (void)mapViewWasDragged:(YMKMapView *)mapView
{
	NSUInteger count = [[DADataController sharedDataController]
		numberOfParkingsForRegion:mapView.region];

	if (count <= kDAMaxVisibelObjects) {
		_clustersVisible = NO;
		[self updateVisibleParkings];
	}
	else if (!_clustersVisible) {
		_clustersVisible = YES;
		[self updateVisibleClusters];
	}
}

- (void)mapView:(YMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
//	NSLog(@"Previous: {{ %f, %f }, { %f, %f }}", _previousRegion.center.latitude, _previousRegion.center.longitude,
//		_previousRegion.span.latitudeDelta, _previousRegion.span.longitudeDelta);
//	NSLog(@"New: {{ %f, %f }, { %f, %f }}\n", mapView.region.center.latitude, mapView.region.center.longitude,
//		mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);

	if (!YMKMapRegionEqualToMapRegion(_previousRegion, mapView.region)) {
		NSUInteger count = [[DADataController sharedDataController]
			numberOfParkingsForRegion:mapView.region];

		if (count <= kDAMaxVisibelObjects) {
			_clustersVisible = NO;
			[self updateVisibleParkings];
		}
		else {
			_clustersVisible = YES;
			[self updateVisibleClusters];
		}
	}
}

- (void)mapView:(YMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	_previousRegion = mapView.region;
}

- (void)mapView:(YMKMapView *)mapView didUpdateUserLocation:(YMKUserLocation *)userLocation
{
	[_listViewController updateUserLocation:userLocation];
}

#pragma mark - DAListViewControllerDelegate

- (void)listViewController:(DAListViewController *)sender didSelectParking:(DAParking *)parking
{
	[self.mapView setCenterCoordinate:YMKMapCoordinateMake(parking.latitude, parking.longitude)
		atZoomLevel:kDADefaultZoomLevel animated:NO];

	[self dismissViewControllerAnimated:YES completion:^{
		self.mapView.selectedAnnotation = parking;
	}];
}

- (void)listViewControllerShouldDismiss:(DAListViewController *)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Private

- (void)updateVisibleParkings
{
	[[DADataController sharedDataController] parkingsForRegion:self.mapView.region
		completion:^(NSArray *parkings)
	{
		NSMutableArray *annotationsToAdd = [parkings mutableCopy];
		NSMutableArray *annotationsToRemove = [self.mapView.annotations mutableCopy];

		id<YMKAnnotation> selectedAnnotation = self.mapView.selectedAnnotation;
		if (nil != selectedAnnotation) {
			NSPredicate *predicate = [NSPredicate predicateWithBlock:
				^BOOL(DAParking *evaluatedObject, NSDictionary *bindings)
			{
				return ![evaluatedObject isEqualToParking:selectedAnnotation];
			}];

			[annotationsToAdd filterUsingPredicate:predicate];
			[annotationsToRemove removeObject:selectedAnnotation];
		}

		[self replaceAnnotations:annotationsToRemove withAnnotations:annotationsToAdd];
	}];
}

- (void)updateVisibleClusters
{
	[[DADataController sharedDataController] clustersForRegion:self.mapView.region
		completion:^(NSArray *clusters)
	{
		NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(DACluster *cluster, NSDictionary *bindings) {
			return [[cluster locations] count] > 0;
		}];

		NSArray *annotationsToAdd = [clusters filteredArrayUsingPredicate:predicate];
		__block NSUInteger max = 0;

		[annotationsToAdd enumerateObjectsUsingBlock:^(DACluster *cluster, NSUInteger idx, BOOL *stop) {
			max = MAX(max, [[cluster locations] count]);
		}];

		_largestCluster = max;
		[self replaceAnnotations:self.mapView.annotations withAnnotations:annotationsToAdd];
	}];
}

- (void)replaceAnnotations:(NSArray *)annotationsToReplace withAnnotations:(NSArray *)newAnnotations
{
	if (nil != annotationsToReplace) {
		[self.mapView removeAnnotations:annotationsToReplace];
	}

	if (nil != newAnnotations) {
		[self.mapView addAnnotations:newAnnotations];
	}
}

- (IBAction)showKyiv:(id)sender
{
	[self.mapView setCenterCoordinate:kDAKyivCoordinates atZoomLevel:kDADefaultZoomLevel animated:YES];
}

- (IBAction)parkHere:(id)sender
{
	DAParking *parking = self.mapView.selectedAnnotation;
	YMKAnnotationView *annotationView = [self.mapView viewForAnnotation:parking];
	[annotationView setSelected:NO animated:YES];

	NSString *carNumber = [[NSUserDefaults standardUserDefaults]
		stringForKey:kDACarNumberUserDefaultsKey];

	if (nil == carNumber) {
		carNumber = @"";
	}

	NSLog(@"%@, %@", parking, carNumber);

//	MFMessageComposeViewController *viewController = [[MFMessageComposeViewController alloc] init];
//	[self presentViewController:viewController animated:YES completion:NULL];
}

@end
