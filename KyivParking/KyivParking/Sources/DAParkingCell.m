//
//  DAParkingCell.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/30/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DAParkingCell.h"


NSString * const kDAParkingCellReuseIdentifier = @"ParkingCell";
const CGFloat kDAParkingCellRowHeight = 66.0f;

@interface DAParkingCell ()

@property (nonatomic, readwrite, weak) IBOutlet UILabel *addressLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *tariffLabel;
@property (nonatomic, readwrite, weak) IBOutlet UILabel *distanceLabel;

@end


@implementation DAParkingCell

@end
