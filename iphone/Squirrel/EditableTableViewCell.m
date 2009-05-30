//
//  EditableTableViewCell.m
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EditableTableViewCell.h"


@implementation EditableTableViewCell

@synthesize textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
		textField.placeholder = @"Name";
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:16.0];
        textField.textColor = [UIColor darkGrayColor];
		
        [self addSubview:textField];
    }
    return self;
}


- (void)layoutSubviews {
    textField.frame = CGRectInset(self.contentView.bounds, 20.0, 0.0);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        textField.textColor = [UIColor whiteColor];
    } else {
        textField.textColor = [UIColor darkGrayColor];
    }
}


- (void)dealloc {
	[textField release];
	
    [super dealloc];
}


@end
