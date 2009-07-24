//
//  InfoTableViewCell.h
//  Squirrel
//
//  Created by Taylan Pince on 02/07/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "InfoTableViewCell.h"
#import "PanelColor.h"

@interface InfoTableViewCellView : UIView

@end


@implementation InfoTableViewCellView

- (void)drawRect:(CGRect)r {
	[(InfoTableViewCell *)[self superview] drawContentView:r];
}

@end


@implementation InfoTableViewCell

@synthesize mainLabel, subLabel, iconType, iconColor;

static UIFont *mainFont = nil;
static UIFont *subFont = nil;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		contentView = [[InfoTableViewCellView alloc] initWithFrame:CGRectZero];
		contentView.opaque = YES;
		contentView.backgroundColor = [UIColor clearColor];
		
		[self addSubview:contentView];
		[contentView release];
		
		mainFont = [UIFont boldSystemFontOfSize:16];
		subFont = [UIFont systemFontOfSize:12];
    }
	
    return self;
}

- (void)dealloc {
	[mainLabel release];
	[subLabel release];
	[iconType release];
	[iconColor release];
	[super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (self.selected != selected) {
		[self setNeedsDisplay];
	}
	
	[super setSelected:selected animated:animated];
}

#ifdef __IPHONE_3_0
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	if (self.highlighted != highlighted) {
		[self setNeedsDisplay];
	}
	
	[super setHighlighted:highlighted animated:animated];
}
#endif

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	if (self.editing != editing) {
		[self setNeedsDisplay];
	}
	
	[super setEditing:editing animated:animated];
}

- (void)setMainLabel:(NSString *)newMainLabel {
	if (mainLabel != newMainLabel) {
		[mainLabel release];
		
		mainLabel = [newMainLabel retain];
		
		[self setNeedsDisplay];
	}
}

- (void)setFrame:(CGRect)f {
	[super setFrame:f];
	CGRect b = [self bounds];
	b.size.height -= 1; // leave room for the seperator line
	[contentView setFrame:b];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect {
	UIColor *mainColour = [UIColor blackColor];
	UIColor *subColour = [UIColor lightGrayColor];
	
	if (self.selected || self.highlighted) {
		mainColour = [UIColor whiteColor];
		subColour = [UIColor whiteColor];
	}
	
	CGPoint top = CGPointMake(20.0, 12.0);
	CGFloat left = (![iconType isEqualToString:@""]) ? 30.0 : 0.0;
	
	[mainColour set];
	
	CGSize textSize = [mainLabel drawInRect:CGRectMake(top.x + left, top.y, rect.size.width - 65.0 - left, 600.0f) withFont:mainFont lineBreakMode:UILineBreakModeWordWrap];
	
	top.y += textSize.height + 2.0;
	
	[subColour set];
	[subLabel drawInRect:CGRectMake(top.x + left, top.y, rect.size.width - 65.0 - left, 600.0f) withFont:subFont lineBreakMode:UILineBreakModeTailTruncation];
	
	if ([iconType isEqualToString:@"Pie Chart"]) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGFloat radius = 14.0;
		CGPoint center = CGPointMake(30.0, 30.0);
		UIColor *panelColor = [PanelColor colorWithName:iconColor alpha:1.0];
		
		CGContextSetFillColorWithColor(context, [panelColor CGColor]);
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddLineToPoint(context, center.x + (radius *  (M_PI / 180.0) * 20.0), center.y + (radius * sin((M_PI / 180.0) * 20.0)));
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, radius, (M_PI / 180.0) * 20.0, (M_PI / 180.0) * 300.0, 0);
		CGContextAddLineToPoint(context, center.x, center.y);
		CGContextClosePath(context);
		CGContextFillPath(context);
		
		CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.75] CGColor]);
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddLineToPoint(context, center.x + (radius * cos((M_PI / 180.0) * 295.0)), center.y + (radius * sin((M_PI / 180.0) * 295.0)));
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, radius, (M_PI / 180.0) * 300.0, (M_PI / 180.0) * 380.0, 0);
		CGContextAddLineToPoint(context, center.x, center.y);
		CGContextClosePath(context);
		CGContextFillPath(context);
	}
}

@end
