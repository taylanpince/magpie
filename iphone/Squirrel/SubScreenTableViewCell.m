//
//  SubScreenTableViewCell.m
//  Squirrel
//
//  Created by Taylan Pince on 02/07/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SubScreenTableViewCell.h"


@implementation SubScreenTableViewCell

@synthesize titleLabel, dataLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		dataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		[titleLabel setTextColor:[UIColor lightGrayColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[dataLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[dataLabel setFont:[UIFont boldSystemFontOfSize:24]];
		
		[self addSubview:titleLabel];
		[self addSubview:dataLabel];
		
		[self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-sub-screen.png"]]];
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	[titleLabel setFrame:CGRectMake(10.0, 8.0, self.contentView.frame.size.width - 20.0, 14.0)];
	[dataLabel setFrame:CGRectMake(10.0, 20.0, self.contentView.frame.size.width - 20.0, 30.0)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	
    if (selected) {
		dataLabel.textColor = [UIColor colorWithRed:0.64 green:0.77 blue:0.88 alpha:1.0];
	} else {
		dataLabel.textColor = [UIColor whiteColor];
	}
}


- (void)dealloc {
	[titleLabel release];
	[dataLabel release];
    [super dealloc];
}


@end
