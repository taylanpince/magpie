//
//  InfoTableViewCell.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "InfoTableViewCell.h"


@implementation InfoTableViewCell

@synthesize mainLabel, subLabel, imageIcon;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		mainLabel.font = [UIFont boldSystemFontOfSize:16.0];
		
        [self addSubview:mainLabel];
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
    mainLabel.frame = CGRectInset(self.contentView.frame, 10.0, 11.0);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	if (selected) {
		mainLabel.textColor = [UIColor whiteColor];
	} else {
		mainLabel.textColor = [UIColor blackColor];
	}
}


- (void)dealloc {
	[mainLabel release];
	[subLabel release];
	[imageIcon release];
    [super dealloc];
}


@end
