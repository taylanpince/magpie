//
//  ScreenTableViewCell.m
//  Magpie
//
//  Created by Taylan Pince on 02/07/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "ScreenTableViewCell.h"


@implementation ScreenTableViewCell

@synthesize valueLabel, active;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		[valueLabel setFont:[UIFont boldSystemFontOfSize:36]];
		[valueLabel setTextColor:[UIColor whiteColor]];
		[valueLabel setTextAlignment:UITextAlignmentCenter];
		[valueLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-screen.png"]]];
		
		[self addSubview:valueLabel];
    }
    return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	[valueLabel setFrame:self.contentView.frame];
	
	if (active) {
		valueLabel.textColor = [UIColor colorWithRed:0.64 green:0.77 blue:0.88 alpha:1.0];
	} else {
		valueLabel.textColor = [UIColor whiteColor];
	}
}


- (void)dealloc {
	[valueLabel release];
    [super dealloc];
}


@end
