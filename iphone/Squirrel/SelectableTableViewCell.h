//
//  SelectableTableViewCell.h
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//


@interface SelectableTableViewCell : UITableViewCell {
	UILabel *titleLabel;
	UILabel *dataLabel;
	
	BOOL blank;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *dataLabel;
@property (nonatomic, assign) BOOL blank;

@end
