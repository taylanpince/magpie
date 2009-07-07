//
//  PanelView.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <math.h>

#import "PanelView.h"
#import "PanelColor.h"
#import "DataPanel.h"
#import "DataItem.h"
#import "DataSet.h"
#import "DataEntry.h"


@implementation PanelView

@synthesize dataPanel, rendered;


#define SMALL_FONT_SIZE 12
#define MAIN_FONT_SIZE 18
#define LARGE_FONT_SIZE 24

static UIFont *smallFont = nil;
static UIFont *smallBoldFont = nil;
static UIFont *mainFont = nil;
static UIFont *largeFont = nil;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		smallFont = [[UIFont systemFontOfSize:SMALL_FONT_SIZE] retain];
		smallBoldFont = [[UIFont boldSystemFontOfSize:SMALL_FONT_SIZE] retain];
        mainFont = [[UIFont boldSystemFontOfSize:MAIN_FONT_SIZE] retain];
        largeFont = [[UIFont boldSystemFontOfSize:LARGE_FONT_SIZE] retain];
		
		[self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)setDataPanel:(DataPanel *)aDataPanel {
	if (dataPanel != aDataPanel) {
		dataPanel = aDataPanel;
		
		CGRect frame = self.frame;
		
		if ([dataPanel.type isEqualToString:@"Horizontal Bar Chart"]) {
			frame.size.height = 70.0 + [dataPanel.dataSet.dataItems count] * 40.0;
		} else if ([dataPanel.type isEqualToString:@"Pie Chart"] || [dataPanel.type isEqualToString:@"Vertical Bar Chart"]) {
			frame.size.height = 280.0 + [dataPanel.dataSet.dataItems count] * 30.0;
		} else if ([dataPanel.type isEqualToString:@"Latest Entry as Words"]) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			NSNumber *numberValue = [[[dataPanel.dataSet latestDataItem] latestDataEntry] value];
			
			[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
			
			CGSize textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
			
			frame.size.height = 70.0 + textSize.height;
			
			[numberFormatter release];
		} else if ([dataPanel.type isEqualToString:@"Latest Entry as Numbers"]) {
			NSNumber *numberValue = [[[dataPanel.dataSet latestDataItem] latestDataEntry] value];
			
			CGSize textSize = [[[numberValue stringValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
			
			frame.size.height = 70.0 + textSize.height;
		} else if ([dataPanel.type isEqualToString:@"Latest Entry Type"]) {
			NSString *entryName = [[dataPanel.dataSet latestDataItem] name];
			
			CGSize textSize = [[entryName uppercaseString] sizeWithFont:mainFont constrainedToSize:CGSizeMake(frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
			
			frame.size.height = 70.0 + textSize.height;
		} else if ([dataPanel.type isEqualToString:@"Total as Words"]) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			NSNumber *numberValue = [NSNumber numberWithDouble:dataPanel.dataSet.total];
			
			[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
			
			CGSize textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
			
			frame.size.height = 70.0 + textSize.height;
			
			[numberFormatter release];
		} else if ([dataPanel.type isEqualToString:@"Total as Numbers"]) {
			NSNumber *numberValue = [NSNumber numberWithDouble:dataPanel.dataSet.total];
			
			CGSize textSize = [[[numberValue stringValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
			
			frame.size.height = 70.0 + textSize.height;
		}
		
		[self setFrame:frame];
		[self setNeedsDisplay];
	}
}


- (void)drawRect:(CGRect)rect {
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
	
	UIColor *panelColor = [PanelColor colorWithName:dataPanel.color alpha:1.0];
	
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
	
	textSize = [[dataPanel.name uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 14.0) withFont:smallBoldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
		
	point.y += textSize.height + 3.0;
	
	NSString *dateText;

	if ([dataPanel.dataSet.lastUpdated timeIntervalSince1970]) {
		NSTimeInterval intervalInSeconds = fabs([dataPanel.dataSet.lastUpdated timeIntervalSinceNow]);
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
	
	textSize = [dateText drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 14.0) withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	
	point.y += textSize.height + 10.0;

	int counter = 0;
	
	if ([dataPanel.type isEqualToString:@"Horizontal Bar Chart"]) {
		for (DataItem *dataItem in dataPanel.dataSet.dataItems) {
			[textColor set];
			
			textSize = [[dataItem.name uppercaseString] drawAtPoint:point forWidth:rect.size.width - 100.0 withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
			
			[[textColor colorWithAlphaComponent:0.5] set];
			
			[[NSString stringWithFormat:@"%1.2f", dataItem.total] drawAtPoint:CGPointMake(point.x + textSize.width + 6.0, point.y + 5.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];

			point.y += textSize.height;
			
			[[panelColor colorWithAlphaComponent:0.5] set];
			
			CGContextAddRect(context, CGRectMake(point.x, point.y, rect.size.width - 20.0, 10.0));
			CGContextFillPath(context);
			
			[panelColor set];
			
			CGContextAddRect(context, CGRectMake(point.x, point.y, ((rect.size.width - 20.0) * dataItem.percentage / 100.0), 10.0));
			CGContextFillPath(context);
			
			point.y += 18.0;

			counter++;
		}
	} else if ([dataPanel.type isEqualToString:@"Vertical Bar Chart"]) {
		point.y += 200.0;
		
		CGPoint topPoint = point;
		CGFloat barHeight;
		CGFloat barWidth = (rect.size.width - 20.0) / [dataPanel.dataSet.dataItems count];
		
		double colorIncrement = 0.9 / [dataPanel.dataSet.dataItems count];
		
		barWidth += barWidth * 0.25 / [dataPanel.dataSet.dataItems count];
		point.y += 12.0;
		
		NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
		NSArray *sortedItems = [dataPanel.dataSet.dataItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
		DataItem *topItem = [sortedItems objectAtIndex:0];
		
		for (DataItem *dataItem in sortedItems) {
			[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
			
			if (dataItem.percentage > 0.0) {
				barHeight = 196.0 * dataItem.percentage / topItem.percentage;
				
				CGContextAddRect(context, CGRectMake(topPoint.x, topPoint.y - barHeight, barWidth * 0.75, barHeight));
				CGContextFillPath(context);
				
				topPoint.x += barWidth;
			}
			
			CGContextAddRect(context, CGRectMake(point.x, point.y, 24.0, 24.0));
			CGContextFillPath(context);
			
			[textColor set];
			
			textSize = [[dataItem.name uppercaseString] drawAtPoint:CGPointMake(point.x + 32.0, point.y) forWidth:rect.size.width - 60.0 withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
			
			[[textColor colorWithAlphaComponent:0.5] set];
			
			[[NSString stringWithFormat:@"%1.2f", dataItem.total] drawAtPoint:CGPointMake(point.x + textSize.width + 38.0, point.y + 5.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
			
			point.y += textSize.height + 8.0;
			
			counter++;
		}
	} else if ([dataPanel.type isEqualToString:@"Pie Chart"]) {
		double totalPercentage = 0.0;
		double colorIncrement = 0.9 / [dataPanel.dataSet.dataItems count];
		
		CGFloat centerX = point.x + (rect.size.width - 20.0) / 2;
		CGFloat radius = 98.0;
		CGFloat centerY = point.y + radius + 6.0;
		CGFloat startAngle;
		CGFloat endAngle;
		
		point.y += 212.0;
		
		CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.15] CGColor]);
		CGContextMoveToPoint(context, centerX, centerY);
		CGContextAddArc(context, centerX, centerY, radius, 0, 2 * M_PI, 0);
		CGContextFillPath(context);
		
		NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
		NSArray *sortedItems = [dataPanel.dataSet.dataItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];

		for (DataItem *dataItem in sortedItems) {
			if (dataItem.percentage > 0.0) {
				CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
				CGContextSetLineWidth(context, 1.0f);
				
				startAngle = ((360.0 * totalPercentage / 100.0) - 5.0) * (M_PI / 180.0);
				endAngle = startAngle + ((360.0 * dataItem.percentage / 100.0) * (M_PI / 180.0));

				CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] CGColor]);
				CGContextMoveToPoint(context, centerX, centerY);
				CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
				CGContextClosePath(context);
				CGContextFillPath(context);
				
				CGContextMoveToPoint(context, centerX, centerY);
				CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
				CGContextStrokePath(context);
				
				CGContextMoveToPoint(context, centerX, centerY);
				CGContextAddLineToPoint(context, centerX + (radius * cos(endAngle)), centerY + (radius * sin(endAngle)));
				CGContextStrokePath(context);
				
				totalPercentage += dataItem.percentage;
			}
			
			[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
			
			CGContextAddRect(context, CGRectMake(point.x, point.y, 24.0, 24.0));
			CGContextFillPath(context);
			
			[textColor set];
			
			textSize = [[dataItem.name uppercaseString] drawAtPoint:CGPointMake(point.x + 32.0, point.y) forWidth:rect.size.width - 60.0 withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
			
			[[textColor colorWithAlphaComponent:0.5] set];
			
			[[NSString stringWithFormat:@"%1.2f", dataItem.total] drawAtPoint:CGPointMake(point.x + textSize.width + 38.0, point.y + 5.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
			
			point.y += textSize.height + 8.0;

			counter++;
		}
	} else if ([dataPanel.type isEqualToString:@"Latest Entry as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		NSNumber *numberValue = [[[dataPanel.dataSet latestDataItem] latestDataEntry] value];
		
		textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;

		[numberFormatter release];
	} else if ([dataPanel.type isEqualToString:@"Latest Entry as Numbers"]) {
		NSNumber *numberValue = [[[dataPanel.dataSet latestDataItem] latestDataEntry] value];

		textSize = [[[numberValue stringValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;
	} else if ([dataPanel.type isEqualToString:@"Latest Entry Type"]) {
		NSString *entryName = [[dataPanel.dataSet latestDataItem] name];
		
		textSize = [[entryName uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:mainFont lineBreakMode:UILineBreakModeWordWrap];
				
		point.y += textSize.height + 6.0;
	} else if ([dataPanel.type isEqualToString:@"Total as Numbers"]) {
		NSNumber *numberValue = [NSNumber numberWithDouble:dataPanel.dataSet.total];
		
		textSize = [[[numberValue stringValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;
	} else if ([dataPanel.type isEqualToString:@"Total as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		NSNumber *numberValue = [NSNumber numberWithDouble:dataPanel.dataSet.total];
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;
		
		[numberFormatter release];
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
