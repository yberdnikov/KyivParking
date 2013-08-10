//
//  DAListViewController.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/28/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAListViewController.h"

#import "DADataController.h"
#import "DAParking.h"
#import "DAParkingCell.h"
#import "DATariffZoneFormatter.h"
#import "DAParkingViewController.h"


enum {
	kDANearbySegmentIndex = 0,
	kDAAllSegmentIndex
};

static const long long int kDANearbyRadius = 500 * 1000;

static NSString * const kDAParkingSegueIdentifier = @"ParkingSegue";


@interface DAListViewController () <DAParkingViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

- (void)reloadData;

- (IBAction)dismiss:(id)sender;
- (IBAction)switchNearbyAll:(UISegmentedControl *)sender;

@end


@implementation DAListViewController {
	DATariffZoneFormatter *_tariffZoneFormatter;
	NSUInteger _selectedSegmentIndex;
	NSArray *_parkings;
	__weak DAParkingViewController *_parkingViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	_tariffZoneFormatter = [DATariffZoneFormatter new];

	[self.tableView setRowHeight:kDAParkingCellRowHeight];
	[self reloadData];
	
	[self.segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
	[self.segmentedControl sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _parkings = nil;
}

- (void)updateUserLocation:(YMKUserLocation *)userLocation
{
	self.userLocation = userLocation;
	[self reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kDAParkingSegueIdentifier]) {
		_parkingViewController = (DAParkingViewController *)segue.destinationViewController;
		_parkingViewController.delegate = self;
	}
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_parkings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAParkingCell *cell = [tableView dequeueReusableCellWithIdentifier:kDAParkingCellReuseIdentifier
		forIndexPath:indexPath];

	DAParking *parking = _parkings[indexPath.row];

	cell.addressLabel.text = parking.address;
	cell.tariffLabel.text = [_tariffZoneFormatter stringFromParking:parking];
	cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f km", parking.distance / 1000.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	DAParking *parking = _parkings[indexPath.row];
	[self.delegate listViewController:self didSelectParking:parking];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	_parkingViewController.parking = _parkings[indexPath.row];
}

#pragma mark - DAParkingViewControllerDelegate <NSObject>

- (void)parkingViewControllerShouldShowMap:(DAParkingViewController *)sender
{
	[self.delegate listViewControllerShouldDismiss:self];
}

#pragma mark - Private

- (void)reloadData
{
	if (kDANearbySegmentIndex == _selectedSegmentIndex) {
		[[DADataController sharedDataController] parkingsAround:self.userLocation.location
			within:kDANearbyRadius completion:^(NSArray *parkings)
		{
			_parkings = parkings;

			if ([self isViewLoaded]) {
				[self.tableView reloadData];
			}
		}];
	}
	else {
		[[DADataController sharedDataController] parkingsAround:self.userLocation.location
			completion:^(NSArray *parkings)
		{
			_parkings = parkings;

			if ([self isViewLoaded]) {
				[self.tableView reloadData];
			}
		}];
	}
}

- (IBAction)dismiss:(id)sender
{
	[self.delegate listViewControllerShouldDismiss:self];
}

- (IBAction)switchNearbyAll:(UISegmentedControl *)sender
{
	_selectedSegmentIndex = sender.selectedSegmentIndex;
//	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
//		atScrollPosition:UITableViewScrollPositionTop animated:YES];
	[self reloadData];
}

@end
