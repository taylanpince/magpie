//
//  ScreenTableViewCell.h
//  Squirrel
//
//  Created by Taylan Pince on 02/07/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//


@interface ScreenTableViewCell : UITableViewCell {
	UILabel *valueLabel;
	
	BOOL active;
}

@property (nonatomic, retain) UILabel *valueLabel;
@property (nonatomic, assign) BOOL active;

@end
