//
//  DAParkingViewController.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/31/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

@class DAParkingViewController;


@protocol DAParkingViewControllerDelegate <NSObject>

- (void)parkingViewControllerShouldShowMap:(DAParkingViewController *)sender;

@end


@class DAParking;


@interface DAParkingViewController : UIViewController

@property (nonatomic, weak) id<DAParkingViewControllerDelegate> delegate;
@property (nonatomic, strong) DAParking *parking;

@end
