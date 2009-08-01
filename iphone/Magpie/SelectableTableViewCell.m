//
//  SelectableTableViewCell.m
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SelectableTableViewCell.h"


@implementation SelectableTableViewCell

@synthesize titleLabel, dataLabel, blank;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		dataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
		dataLabel.font = [UIFont systemFontOfSize:16.0];
		
		[self addSubview:titleLabel];
		[self addSubview:dataLabel];
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
    titleLabel.frame = CGRectMake(20.0, 10.0, 100.0, self.contentView.frame.size.height - 20.0);
	dataLabel.frame = CGRectMake(120.0, 10.0, self.contentView.frame.size.width - 120.0, self.contentView.frame.size.height - 20.0);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
		titleLabel.textColor = [UIColor whiteColor];
		dataLabel.textColor = [UIColor whiteColor];
	} else {
		titleLabel.textColor = [UIColor blackColor];
		dataLabel.textColor = (blank) ? [UIColor lightGrayColor] : [UIColor blackColor];
	}
}


#ifdef __IPHONE_3_0
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
	
    if (highlighted) {
		titleLabel.textColor = [UIColor whiteColor];
		dataLabel.textColor = [UIColor whiteColor];
	} else {
		titleLabel.textColor = [UIColor blackColor];
		dataLabel.textColor = (blank) ? [UIColor lightGrayColor] : [UIColor blackColor];
	}
}
#endif


- (void)dealloc {
	[titleLabel release];
	[dataLabel release];
    [super dealloc];
}


@end
