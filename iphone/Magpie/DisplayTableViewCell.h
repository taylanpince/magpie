//
//  DisplayTableViewCell.h
//  Magpie
//
//  Created by Taylan Pince on 09-12-25.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Display;

@interface DisplayTableViewCell : UITableViewCell {
	UIView *contentView;
	UIImage *statImage;
	
	Display *display;
}

@property (nonatomic, retain) Display *display;
@property (nonatomic, retain) UIImage *statImage;

- (void)drawContentView:(CGRect)rect;

@end
