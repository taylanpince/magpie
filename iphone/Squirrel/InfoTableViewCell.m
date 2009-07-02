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
		subLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		mainLabel.font = [UIFont boldSystemFontOfSize:16.0];
		subLabel.font = [UIFont systemFontOfSize:12.0];
		
        [self addSubview:mainLabel];
		[self addSubview:subLabel];
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
    mainLabel.frame = CGRectMake(self.contentView.frame.origin.x + 10.0, self.contentView.frame.origin.y + 10.0, self.contentView.frame.size.width - 20.0, 20.0);
	
	if ([subLabel.text isEqualToString:@""] | subLabel.text == nil) {
		subLabel.hidden = YES;
	} else {
		subLabel.hidden = NO;
		subLabel.frame = CGRectMake(self.contentView.frame.origin.x + 10.0, mainLabel.frame.origin.y + mainLabel.frame.size.height, self.contentView.frame.size.width - 20.0, 20.0);
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	if (selected) {
		mainLabel.textColor = [UIColor whiteColor];
		subLabel.textColor = [UIColor whiteColor];
	} else {
		mainLabel.textColor = [UIColor blackColor];
		subLabel.textColor = [UIColor lightGrayColor];
	}
}


#ifdef __IPHONE_3_0
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
	
    if (highlighted) {
		mainLabel.textColor = [UIColor whiteColor];
		subLabel.textColor = [UIColor whiteColor];
	} else {
		mainLabel.textColor = [UIColor blackColor];
		subLabel.textColor = [UIColor lightGrayColor];
	}
}
#endif


- (void)dealloc {
	[mainLabel release];
	[subLabel release];
	[imageIcon release];
    [super dealloc];
}


@end
