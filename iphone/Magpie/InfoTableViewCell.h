//
//  InfoTableViewCell.h
//  Magpie
//
//  Created by Taylan Pince on 02/07/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@interface InfoTableViewCell : UITableViewCell {
	UIView *contentView;
	
	NSString *mainLabel;
	NSString *subLabel;
	NSString *iconType;
	NSString *iconColor;
}

@property (nonatomic, retain) NSString *mainLabel;
@property (nonatomic, retain) NSString *subLabel;
@property (nonatomic, retain) NSString *iconType;
@property (nonatomic, retain) NSString *iconColor;

- (void)drawContentView:(CGRect)rect;

@end
