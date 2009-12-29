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
#import "Category.h"


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

static UIFont *smallFont = nil;
static UIFont *smallBoldFont = nil;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		contentView = [[DisplayTableViewCellView alloc] initWithFrame:CGRectZero];
		
		[contentView setOpaque:YES];
		[contentView setBackgroundColor:[UIColor clearColor]];
		
		[self addSubview:contentView];
		[contentView release];
		
		smallFont = [[UIFont systemFontOfSize:SMALL_FONT_SIZE] retain];
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

- (void)setFrame:(CGRect)rect {
	[super setFrame:rect];
	[contentView setFrame:[self bounds]];
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
	rect.size.height -= 24.0;
	rect.origin.x += 10.0;
	rect.origin.y += 10.0;
	
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
	
	CGContextAddRect(context, CGRectMake(0.0, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + header_height));
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
	
	CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, rect.origin.y), CGPointMake(0.0, rect.origin.y + header_height), 0);
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
	
	CGContextDrawLinearGradient(context, bottom_gradient, CGPointMake(0.0, rect.origin.y + rect.size.height - 6.0), CGPointMake(0.0, rect.origin.y + rect.size.height), 0);
	CGGradientRelease(bottom_gradient);
	
	CGSize textSize;
	CGPoint point = CGPointMake(rect.origin.x + 10.0, rect.origin.y + 5.0);
	UIColor *textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
	
	[textColor set];
	
	textSize = [[display.name uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 14.0) withFont:smallBoldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	
	point.y += textSize.height + 3.0;
	
	NSString *dateText;
	
	if ([display.category.lastUpdated timeIntervalSince1970]) {
		NSTimeInterval intervalInSeconds = fabs([display.category.lastUpdated timeIntervalSinceNow]);
		double intervalInMinutes = round(intervalInSeconds / 60.0);
		
		if (intervalInMinutes >= 0 && intervalInMinutes <= 1) dateText = (intervalInMinutes == 0) ? @"less than a minute ago" : @"1 minute ago";
		else if (intervalInMinutes >= 2 && intervalInMinutes <= 44) dateText = [NSString stringWithFormat:@"%.0f minutes ago", intervalInMinutes];
		else if (intervalInMinutes >= 45 && intervalInMinutes <= 89) dateText = @"about 1 hour ago";
		else if (intervalInMinutes >= 90 && intervalInMinutes <= 1439) dateText = [NSString stringWithFormat:@"about %.0f hours ago", round(intervalInMinutes / 60.0)];
		else if (intervalInMinutes >= 1440 && intervalInMinutes <= 2879) dateText = @"1 day ago";
		else if (intervalInMinutes >= 2880 && intervalInMinutes <= 43199) dateText = [NSString stringWithFormat:@"%.0f days ago", round(intervalInMinutes / 1440.0)];
		else if (intervalInMinutes >= 43200 && intervalInMinutes <= 86399) dateText = @"about 1 month ago";
		else if (intervalInMinutes >= 86400 && intervalInMinutes <= 525599) dateText = [NSString stringWithFormat:@"%.0f months ago", round(intervalInMinutes / 43200.0)];
		else if (intervalInMinutes >= 525600 && intervalInMinutes <= 1051199) dateText = @"about 1 year ago";
		else dateText = [NSString stringWithFormat:@"over %.0f years ago", round(intervalInMinutes / 525600.0)];
	} else {
		dateText = @"N/A";
	}
	
	[dateText drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 14.0) withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
}

- (void)dealloc {
	[display release];
	[statImage release];
    [super dealloc];
}

@end