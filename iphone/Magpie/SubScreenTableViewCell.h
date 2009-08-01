//
//  SubScreenTableViewCell.h
//  Magpie
//
//  Created by Taylan Pince on 02/07/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//


@interface SubScreenTableViewCell : UITableViewCell {
	UILabel *titleLabel;
	UILabel *dataLabel;
	
	BOOL active;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *dataLabel;

@property (nonatomic, assign) BOOL active;

@end
