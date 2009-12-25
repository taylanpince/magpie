//
//  DisplayTableViewCell.m
//  Magpie
//
//  Created by Taylan Pince on 09-12-25.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "DisplayTableViewCell.h"
#import "PanelColor.h"
#import "Display.h"


@interface DisplayTableViewCellView : UIView

@end

@implementation DisplayTableViewCellView

- (void)drawRect:(CGRect)rect {
	[(DisplayTableViewCell *)[self superview] drawContentView:rect];
}

@end


@implementation DisplayTableViewCell

@synthesize display, statImage;

#define SMALL_FONT_SIZE 12

static UIFont *smallBoldFont = nil;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		contentView = [[DisplayTableViewCellView alloc] initWithFrame:CGRectZero];
		
		[contentView setOpaque:YES];
		[contentView setBackgroundColor:[UIColor clearColor]];
		
		[self addSubview:contentView];
		[contentView release];
		
		smallBoldFont = [[UIFont boldSystemFontOfSize:SMALL_FONT_SIZE] retain];
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (self.selected != selected) {
		[self setNeedsDisplay];
	}
	
	[super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	if (self.highlighted != highlighted) {
		[self setNeedsDisplay];
	}
	
	[super setHighlighted:highlighted animated:animated];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	if (self.editing != editing) {
		[self setNeedsDisplay];
	}
	
	[super setEditing:editing animated:animated];
}

- (void)setDisplay:(Display *)newDisplay {
	if (display != newDisplay) {
		[display release];
		
		display = [newDisplay retain];
		
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

- (void)layoutSubviews {
	[super layoutSubviews];
	[contentView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	rect.size.width -= 20.0;
	rect.size.height -= 14.0;
	rect.origin.x += 10.0;
	
	CGContextSaveGState(context);
	CGContextSetShadow(context, CGSizeMake(2.0, -8.0), 4.0);
	CGContextSetRGBFillColor(context, 0.88, 0.88, 0.88, 1.0);
	
	int corner_radius = 10;
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x + corner_radius, rect.origin.y, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - corner_radius, rect.origin.y);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, rect.origin.x + rect.size.width - corner_radius, rect.origin.y + rect.size.height, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + corner_radius, rect.origin.y + rect.size.height);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y + rect.size.height - corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextClosePath(context);
	
	CGContextFillPath(context);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
	
	int header_height = 40;
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x + corner_radius, rect.origin.y, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - corner_radius, rect.origin.y);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + header_height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + header_height);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextClosePath(context);
	
	CGContextClip(context);
	
	UIColor *panelColor = [PanelColor colorWithName:display.color alpha:1.0];
	
	[panelColor set];
	
	CGContextAddRect(context, CGRectMake(0.0, 0.0, rect.origin.x + rect.size.width, header_height));
	
	CGContextFillPath(context);
	
	size_t num_locations = 6;
	CGFloat locations[6] = {
		0.0,
		0.025,
		0.5,
		0.5,
		0.975,
		1.0
	};
	
	CGFloat components[24] = {
		1.0, 1.0, 1.0, 0.5,
		0.75, 0.75, 0.75, 0.5,
		0.6, 0.6, 0.6, 0.5,
		0.5, 0.5, 0.5, 0.5,
		0.25, 0.25, 0.25, 0.5,
		0.0, 0.0, 0.0, 0.5
	};
	
	CGGradientRef gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), components, locations, num_locations);
	
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(0.0, header_height), 0);
	
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x + corner_radius, rect.origin.y, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - corner_radius, rect.origin.y);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - corner_radius);
	CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, rect.origin.x + rect.size.width - corner_radius, rect.origin.y + rect.size.height, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x + corner_radius, rect.origin.y + rect.size.height);
	CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y + rect.size.height - corner_radius, corner_radius);
	CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + corner_radius);
	CGContextClosePath(context);
	
	CGContextClip(context);
	
	size_t bottom_locations_num = 2;
	CGFloat bottom_locations[2] = {
		0.0,
		1.0
	};
	
	CGFloat bottom_components[16] = {
		0.88, 0.88, 0.88, 1.0,
		0.6, 0.6, 0.6, 1.0
	};
	
	CGGradientRef bottom_gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), bottom_components, bottom_locations, bottom_locations_num);
	
	CGContextDrawLinearGradient(context, bottom_gradient, CGPointMake(0.0, rect.size.height - 6.0), CGPointMake(0.0, rect.size.height), 0);
	
	CGGradientRelease(bottom_gradient);
	
	CGSize textSize;
	CGPoint point = CGPointMake(rect.origin.x + 10.0, rect.origin.y + 5.0);
	UIColor *textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
	
	[textColor set];
	
	textSize = [[display.name uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 14.0) withFont:smallBoldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	
	point.y += textSize.height + 3.0;
}

- (void)dealloc {
	[display release];
	[statImage release];
    [super dealloc];
}

@end