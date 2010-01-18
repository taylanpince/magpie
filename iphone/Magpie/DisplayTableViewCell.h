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
	UIImageView *imageView;
	UIActivityIndicatorView *activityIndicator;
	
	BOOL hasImage;
	
	Display *display;
}

@property (nonatomic, retain) Display *display;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

- (void)drawContentView:(CGRect)rect;
- (void)setStatImage:(UIImage *)statImage;

@end
