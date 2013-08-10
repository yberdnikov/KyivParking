//
//  DAParkingCell.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/30/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


@interface DAParkingCell : UITableViewCell

@property (nonatomic, readonly) UILabel *addressLabel;
@property (nonatomic, readonly) UILabel *tariffLabel;
@property (nonatomic, readonly) UILabel *distanceLabel;

@end


extern NSString * const kDAParkingCellReuseIdentifier;
extern const CGFloat kDAParkingCellRowHeight;
