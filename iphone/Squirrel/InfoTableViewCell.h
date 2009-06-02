//
//  InfoTableViewCell.h
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//


@interface InfoTableViewCell : UITableViewCell {
	UILabel *mainLabel;
	UILabel *subLabel;
	UIImageView *imageIcon;
}

@property (nonatomic, retain) UILabel *mainLabel;
@property (nonatomic, retain) UILabel *subLabel;
@property (nonatomic, retain) UIImageView *imageIcon;

@end
