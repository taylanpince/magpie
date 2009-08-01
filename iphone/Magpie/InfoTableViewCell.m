//
//  InfoTableViewCell.h
//  Magpie
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

- (void)setSubLabel:(NSString *)newSubLabel {
	if (subLabel != newSubLabel) {
		[subLabel release];
		
		subLabel = [newSubLabel retain];
		
		[self setNeedsDisplay];
	}
}

- (void)setIconType:(NSString *)newIconType {
	if (iconType != newIconType) {
		[iconType release];
		
		iconType = [newIconType retain];
		
		[self setNeedsDisplay];
	}
}

- (void)setIconColor:(NSString *)newIconColor {
	if (iconColor != newIconColor) {
		[iconColor release];
		
		iconColor = [newIconColor retain];
		
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
	
	if (self.selected) {
		mainColour = [UIColor whiteColor];
		subColour = [UIColor whiteColor];
	}
	
	CGPoint top = CGPointMake(20.0, 12.0);
	CGFloat leftOffset = (![iconType isEqualToString:@""] || self.editing) ? 34.0 : 0.0;
	CGFloat topOffset = ([subLabel isEqualToString:@""] && ![iconType isEqualToString:@""]) ? 6.0 : 0.0;
	
	[mainColour set];
	
	CGSize textSize = [mainLabel drawInRect:CGRectMake(top.x + leftOffset, top.y + topOffset, rect.size.width - 65.0 - leftOffset, 600.0f) withFont:mainFont lineBreakMode:UILineBreakModeWordWrap];
	
	top.y += textSize.height + 2.0;
	
	if (![subLabel isEqualToString:@""]) {
		[subColour set];
		[subLabel drawInRect:CGRectMake(top.x + leftOffset, top.y, rect.size.width - 65.0 - leftOffset, 20.0f) withFont:subFont lineBreakMode:UILineBreakModeTailTruncation];
	}
	
	if (![iconType isEqualToString:@""] && !self.editing) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		UIColor *panelColor = [PanelColor colorWithName:iconColor alpha:1.0];
		
		if ([iconType isEqualToString:@"Pie Chart"]) {
			CGFloat radius = 14.0;
			CGPoint center = CGPointMake(32.0, 30.0);
			
			CGContextSetFillColorWithColor(context, [panelColor CGColor]);
			CGContextMoveToPoint(context, center.x, center.y);
			CGContextAddLineToPoint(context, center.x + (radius *  (M_PI / 180.0) * 20.0), center.y + (radius * sin((M_PI / 180.0) * 20.0)));
			CGContextMoveToPoint(context, center.x, center.y);
			CGContextAddArc(context, center.x, center.y, radius, (M_PI / 180.0) * 20.0, (M_PI / 180.0) * 300.0, 0);
			CGContextAddLineToPoint(context, center.x, center.y);
			CGContextClosePath(context);
			CGContextFillPath(context);
			
			CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.5] CGColor]);
			CGContextMoveToPoint(context, center.x, center.y);
			CGContextAddLineToPoint(context, center.x + (radius * cos((M_PI / 180.0) * 295.0)), center.y + (radius * sin((M_PI / 180.0) * 295.0)));
			CGContextMoveToPoint(context, center.x, center.y);
			CGContextAddArc(context, center.x, center.y, radius, (M_PI / 180.0) * 300.0, (M_PI / 180.0) * 380.0, 0);
			CGContextAddLineToPoint(context, center.x, center.y);
			CGContextClosePath(context);
			CGContextFillPath(context);
		} else if ([iconType isEqualToString:@"Horizontal Bar Chart"]) {
			CGContextSetFillColorWithColor(context, [panelColor CGColor]);
			CGContextFillRect(context, CGRectMake(18.0, 16.0, 20.0, 6.0));
			CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.75] CGColor]);
			CGContextFillRect(context, CGRectMake(18.0, 24.0, 28.0, 6.0));
			CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.5] CGColor]);
			CGContextFillRect(context, CGRectMake(18.0, 32.0, 14.0, 6.0));
		} else if ([iconType isEqualToString:@"Vertical Bar Chart"] || [iconType isEqualToString:@"Daily Timeline"] || [iconType isEqualToString:@"Monthly Timeline"]) {
			CGContextSetFillColorWithColor(context, [panelColor CGColor]);
			CGContextFillRect(context, CGRectMake(18.0, 24.0, 6.0, 20.0));
			CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.75] CGColor]);
			CGContextFillRect(context, CGRectMake(26.0, 16.0, 6.0, 28.0));
			CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.5] CGColor]);
			CGContextFillRect(context, CGRectMake(34.0, 30.0, 6.0, 14.0));
		} else if ([iconType isEqualToString:@"Latest Entry as Words"] || [iconType isEqualToString:@"Largest Entry as Words"] || [iconType isEqualToString:@"Latest Entry Type"] || [iconType isEqualToString:@"Largest Entry Type"] || [iconType isEqualToString:@"Average Entry as Words"] || [iconType isEqualToString:@"Total as Words"]) {
			[panelColor set];
			[@"Aa" drawInRect:CGRectMake(18.0, 16.0, 28.0, 28.0) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap];
		} else if ([iconType isEqualToString:@"Latest Entry as Numbers"] || [iconType isEqualToString:@"Largest Entry as Numbers"] || [iconType isEqualToString:@"Average Entry as Numbers"] || [iconType isEqualToString:@"Total as Numbers"]) {
			[panelColor set];
			[@"1.2" drawInRect:CGRectMake(18.0, 16.0, 28.0, 28.0) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:UILineBreakModeWordWrap];
		} else if ([iconType isEqualToString:@"Color"]) {
			CGContextSetFillColorWithColor(context, [panelColor CGColor]);
			CGContextFillRect(context, CGRectMake(18.0, 16.0, 28.0, 28.0));
		}
	}
}

@end
