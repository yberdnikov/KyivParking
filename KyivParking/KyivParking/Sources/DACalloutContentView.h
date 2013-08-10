//
//  DACalloutContentView.h
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/12/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//


@interface DACalloutContentView : UIView <YMKCalloutContentView>

@property (nonatomic, readonly) UILabel *addressLabel;
@property (nonatomic, readonly) UILabel *tariffLabel;
@property (nonatomic, readonly) UIButton *parkHereButton;

@end
