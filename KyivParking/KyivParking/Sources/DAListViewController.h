//
//  DAListViewController.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/28/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

@class DAListViewController;
@class DAParking;


@protocol DAListViewControllerDelegate <NSObject>

- (void)listViewController:(DAListViewController *)sender didSelectParking:(DAParking *)parking;
- (void)listViewControllerShouldDismiss:(DAListViewController *)sender;

@end


@interface DAListViewController : UITableViewController

@property (nonatomic, weak) id<DAListViewControllerDelegate> delegate;
@property (nonatomic, assign) YMKUserLocation *userLocation;

- (void)updateUserLocation:(YMKUserLocation *)userLocation;

@end
