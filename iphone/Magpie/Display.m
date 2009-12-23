// 
//  Display.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "Display.h"

#import "Category.h"

@implementation Display 

@dynamic weight;
@dynamic name;
@dynamic type;
@dynamic color;
@dynamic category;

- (CGFloat)heightForDisplay {
	CGFloat height = 0.0;
	CGFloat width = [[[[UIScreen mainScreen] applicationFrame] size] width] - 40.0;
	
	UIFont *largeFont = [UIFont boldSystemFontOfSize:24];
	
	if ([type isEqualToString:@"Horizontal Bar Chart"]) {
		height = 70.0 + [category.items count] * 40.0;
	} else if ([type isEqualToString:@"Pie Chart"] || [type isEqualToString:@"Vertical Bar Chart"]) {
		height = 280.0 + ceil([category.items count] / 2.0) * 24.0;
	} else if ([type isEqualToString:@"Latest Entry as Words"] || [type isEqualToString:@"Largest Entry as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		NSNumber *numberValue;
		
		if ([type isEqualToString:@"Latest Entry as Words"]) {
			numberValue = [[[category latestItem] latestEntry] value];
		} else if ([type isEqualToString:@"Largest Entry as Words"]) {
			numberValue = [[category largestEntry] value];
		}
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		CGSize textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(frame.size.width - 40.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
		
		[numberFormatter release];
	} else if ([type isEqualToString:@"Latest Entry as Numbers"] || [type isEqualToString:@"Largest Entry as Numbers"]) {
		NSNumber *numberValue;
		
		if ([type isEqualToString:@"Latest Entry as Words"]) {
			numberValue = [[[category latestItem] latestEntry] value];
		} else if ([type isEqualToString:@"Largest Entry as Numbers"]) {
			numberValue = [[category largestEntry] value];
		}
		
		CGSize textSize = [[[numberValue stringValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		frame.size.height = 70.0 + textSize.height;
	} else if ([type isEqualToString:@"Latest Entry Type"] || [type isEqualToString:@"Largest Entry Type"]) {
		NSString *entryName;
		
		if ([type isEqualToString:@"Latest Entry Type"]) {
			entryName = [[category latestItem] name];
		} else if ([type isEqualToString:@"Largest Entry Type"]) {
			entryName = [[category largestItem] name];
		}
		
		CGSize textSize = [[entryName uppercaseString] sizeWithFont:mainFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
	} else if ([type isEqualToString:@"Total as Words"] || [type isEqualToString:@"Average Entry as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		NSNumber *numberValue;
		
		if ([type isEqualToString:@"Total as Words"]) {
			numberValue = [NSNumber numberWithDouble:[category total]];
		} else if ([type isEqualToString:@"Average Entry as Words"]) {
			numberValue = [NSNumber numberWithDouble:[NSString stringWithFormat:@"%1.2f", [category averageEntryValue]]];
		}
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		CGSize textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
		
		[numberFormatter release];
	} else if ([type isEqualToString:@"Total as Numbers"] || [type isEqualToString:@"Average Entry as Numbers"]) {
		NSNumber *numberValue;
		
		if ([type isEqualToString:@"Total as Numbers"]) {
			numberValue = [NSNumber numberWithDouble:[category total]];
		} else if ([type isEqualToString:@"Average Entry as Numbers"]) {
			numberValue = [NSNumber numberWithDouble:[NSString stringWithFormat:@"%1.2f", [category averageEntryValue]]];
		}
		
		CGSize textSize = [[[numberValue stringValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
	} else if ([type isEqualToString:@"Daily Timeline"] || [type isEqualToString:@"Monthly Timeline"]) {
		height = 288.0 + ceil([category.items count] / 2.0) * 24.0;
	}
	
	return height;
}

- (UIImage *)imageForDisplay {
	CGRect rect = CGRectMake(10.0, 0.0, [[[[UIScreen mainScreen] applicationFrame] size] width], [self heightForDisplay]);
	CGContextRef context = CreateCGBitmapContextForWidthAndHeight(rect.size.width, rect.size.height, NULL, kDefaultCGBitmapInfoNoAlpha);
	
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
	
	textSize = [[dataPanel.name uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 14.0) withFont:smallBoldFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	
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
	
	textSize = [dateText drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 14.0) withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	
	point.y += textSize.height + 10.0;
	
	int counter = 0;
	
	if ([display.type isEqualToString:@"Horizontal Bar Chart"]) {
		for (Item *dataItem in display.category.items) {
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
	} else if ([display.type isEqualToString:@"Vertical Bar Chart"]) {
		point.y += 200.0;
		
		[[UIColor lightGrayColor] set];
		
		CGContextSetLineWidth(context, 1.0f);
		CGContextMoveToPoint(context, point.x - 5.0, point.y + 1.0);
		CGContextAddLineToPoint(context, rect.size.width + 5.0, point.y + 1.0);
		CGContextStrokePath(context);
		
		CGPoint topPoint = point;
		CGSize totalSize;
		NSString *totalText;
		CGFloat barHeight;
		CGFloat barWidth = (rect.size.width - 20.0) / [display.category.items count];
		
		double colorIncrement = 0.9 / [display.category.items count];
		
		barWidth += barWidth * 0.25 / [display.category.items count];
		point.y += 12.0;
		
		NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
		NSArray *sortedItems = [display.category.items sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
		DataItem *topItem = [sortedItems objectAtIndex:0];
		
		for (DataItem *dataItem in sortedItems) {
			[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
			
			if (dataItem.percentage > 0.0) {
				barHeight = 196.0 * dataItem.percentage / topItem.percentage;
				
				CGContextAddRect(context, CGRectMake(topPoint.x, topPoint.y - barHeight, barWidth * 0.75, barHeight));
				CGContextFillPath(context);
				
				topPoint.x += barWidth;
			}
			
			point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
			
			CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
			CGContextFillPath(context);
			
			[textColor set];
			
			totalText = [NSString stringWithFormat:@"%1.2f", dataItem.total];
			totalSize = [totalText sizeWithFont:smallFont forWidth:40.0 lineBreakMode:UILineBreakModeTailTruncation];
			textSize = [[dataItem.name uppercaseString] drawAtPoint:CGPointMake(point.x + 20.0, point.y) forWidth:(rect.size.width - 20.0) / 2 - totalSize.width - 30.0 withFont:mediumFont lineBreakMode:UILineBreakModeTailTruncation];
			
			[[textColor colorWithAlphaComponent:0.5] set];
			
			[totalText drawAtPoint:CGPointMake(point.x + textSize.width + 24.0, point.y + 3.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
			
			if (counter % 2 > 0) point.y += textSize.height + 5.0;
			
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
		
		CGSize totalSize;
		NSString *totalText;
		
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
			
			point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
			
			[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
			
			CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
			CGContextFillPath(context);
			
			[textColor set];
			
			totalText = [NSString stringWithFormat:@"%1.2f", dataItem.total];
			totalSize = [totalText sizeWithFont:smallFont forWidth:40.0 lineBreakMode:UILineBreakModeTailTruncation];
			textSize = [[dataItem.name uppercaseString] drawAtPoint:CGPointMake(point.x + 20.0, point.y) forWidth:(rect.size.width - 20.0) / 2 - totalSize.width - 30.0 withFont:mediumFont lineBreakMode:UILineBreakModeTailTruncation];
			
			[[textColor colorWithAlphaComponent:0.5] set];
			
			[totalText drawAtPoint:CGPointMake(point.x + textSize.width + 24.0, point.y + 3.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
			
			if (counter % 2 > 0) point.y += textSize.height + 5.0;
			
			counter++;
		}
	} else if ([dataPanel.type isEqualToString:@"Latest Entry as Words"] || [dataPanel.type isEqualToString:@"Largest Entry as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		NSNumber *numberValue;
		
		if ([dataPanel.type isEqualToString:@"Latest Entry as Words"]) {
			numberValue = [[[dataPanel.dataSet latestDataItem] latestDataEntry] value];
		} else if ([dataPanel.type isEqualToString:@"Largest Entry as Words"]) {
			numberValue = [[dataPanel.dataSet largestDataEntry] value];
		}
		
		textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;
		
		[numberFormatter release];
	} else if ([dataPanel.type isEqualToString:@"Latest Entry as Numbers"] || [dataPanel.type isEqualToString:@"Largest Entry as Numbers"]) {
		NSNumber *numberValue;
		
		if ([dataPanel.type isEqualToString:@"Latest Entry as Numbers"]) {
			numberValue = [[[dataPanel.dataSet latestDataItem] latestDataEntry] value];
		} else if ([dataPanel.type isEqualToString:@"Largest Entry as Numbers"]) {
			numberValue = [[dataPanel.dataSet largestDataEntry] value];
		}
		
		textSize = [[[numberValue stringValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;
	} else if ([dataPanel.type isEqualToString:@"Latest Entry Type"] || [dataPanel.type isEqualToString:@"Largest Entry Type"]) {
		NSString *entryName;
		
		if ([dataPanel.type isEqualToString:@"Latest Entry Type"]) {
			entryName = [[dataPanel.dataSet latestDataItem] name];
		} else if ([dataPanel.type isEqualToString:@"Largest Entry Type"]) {
			entryName = [[dataPanel.dataSet largestDataItem] name];
		}
		
		textSize = [[entryName uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:mainFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;
	} else if ([dataPanel.type isEqualToString:@"Total as Numbers"] || [dataPanel.type isEqualToString:@"Average Entry as Numbers"]) {
		NSNumber *numberValue;
		
		if ([dataPanel.type isEqualToString:@"Total as Numbers"]) {
			numberValue = [NSNumber numberWithDouble:dataPanel.dataSet.total];
		} else if ([dataPanel.type isEqualToString:@"Average Entry as Numbers"]) {
			numberValue = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%1.2f", [dataPanel.dataSet averageEntry]] doubleValue]];
		}
		
		textSize = [[[numberValue stringValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;
	} else if ([dataPanel.type isEqualToString:@"Total as Words"] || [dataPanel.type isEqualToString:@"Average Entry as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		NSNumber *numberValue;
		
		if ([dataPanel.type isEqualToString:@"Total as Words"]) {
			numberValue = [NSNumber numberWithDouble:dataPanel.dataSet.total];
		} else if ([dataPanel.type isEqualToString:@"Average Entry as Words"]) {
			numberValue = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%1.2f", [dataPanel.dataSet averageEntry]] doubleValue]];
		}
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
		
		point.y += textSize.height + 6.0;
		
		[numberFormatter release];
	} else if ([dataPanel.type isEqualToString:@"Daily Timeline"]) {
		point.y += 200.0;
		
		[[UIColor lightGrayColor] set];
		
		CGContextSetLineWidth(context, 1.0f);
		CGContextMoveToPoint(context, point.x - 5.0, point.y + 1.0);
		CGContextAddLineToPoint(context, rect.size.width + 5.0, point.y + 1.0);
		CGContextStrokePath(context);
		
		CGPoint topPoint = point;
		CGFloat barHeight;
		CGFloat barPosition;
		CGFloat barWidth = (rect.size.width - 20.0) / 30.0;
		
		double colorIncrement = 0.9 / [dataPanel.dataSet.dataItems count];
		
		barWidth += barWidth * 0.25 / 30;
		point.y += 2.0;
		
		NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
		NSArray *sortedItems = [dataPanel.dataSet.dataItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-1 * 60 * 60 * 24 * 29];
		
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[[dateFormatter stringFromDate:startDate] drawAtPoint:point forWidth:rect.size.width - 60.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
		
		CGSize dateSize = [[dateFormatter stringFromDate:[NSDate date]] sizeWithFont:smallFont constrainedToSize:CGSizeMake(rect.size.width - 60.0, rect.size.height) lineBreakMode:UILineBreakModeTailTruncation];
		
		[[dateFormatter stringFromDate:[NSDate date]] drawAtPoint:CGPointMake(rect.size.width - dateSize.width, point.y) forWidth:rect.size.width - 60.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
		
		[dateFormatter release];
		
		point.y += 20.0;
		
		CGContextSetRGBStrokeColor(context, 0.88, 0.88, 0.88, 1.0);
		
		NSMutableArray *dayTotals = [[NSMutableArray alloc] init];
		
		for (NSUInteger i = 0; i < 30; i++) {
			[dayTotals addObject:[NSNumber numberWithDouble:[dataPanel.dataSet totalForDay:[startDate addTimeInterval:i * 60 * 60 * 24]]]];
		}
		
		sorter = [[[NSSortDescriptor alloc] initWithKey:@"doubleValue" ascending:NO] autorelease];
		double largestDayTotal = [[[dayTotals sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]] objectAtIndex:0] doubleValue];
		
		for (NSUInteger i = 0; i < 30; i++) {
			if ([[dayTotals objectAtIndex:i] doubleValue] > 0) {
				counter = 0;
				barPosition = 0.0;
				
				for (DataItem *dataItem in sortedItems) {
					barHeight = 196.0 * [dataItem totalForDay:[startDate addTimeInterval:i * 60 * 60 * 24]] / largestDayTotal;
					
					if (barHeight > 0.0) {
						CGRect rect = CGRectMake(topPoint.x, topPoint.y - barHeight - barPosition, barWidth * 0.75, barHeight);
						
						CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] CGColor]);
						CGContextFillRect(context, rect);
						CGContextStrokeRect(context, rect);
						
						barPosition += barHeight;
					}
					
					counter++;
				}
			}
			
			topPoint.x += barWidth;
		}
		
		[dayTotals release];
		
		counter = 0;
		
		CGSize totalSize;
		NSString *totalText;
		
		for (DataItem *dataItem in sortedItems) {
			point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
			
			[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
			
			CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
			CGContextFillPath(context);
			
			[textColor set];
			
			totalText = [NSString stringWithFormat:@"%1.2f", dataItem.total];
			totalSize = [totalText sizeWithFont:smallFont forWidth:40.0 lineBreakMode:UILineBreakModeTailTruncation];
			textSize = [[dataItem.name uppercaseString] drawAtPoint:CGPointMake(point.x + 20.0, point.y) forWidth:(rect.size.width - 20.0) / 2 - totalSize.width - 30.0 withFont:mediumFont lineBreakMode:UILineBreakModeTailTruncation];
			
			[[textColor colorWithAlphaComponent:0.5] set];
			
			[totalText drawAtPoint:CGPointMake(point.x + textSize.width + 24.0, point.y + 3.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
			
			if (counter % 2 > 0) point.y += textSize.height + 5.0;
			
			counter++;
		}
	} else if ([dataPanel.type isEqualToString:@"Monthly Timeline"]) {
		point.y += 200.0;
		
		[[UIColor lightGrayColor] set];
		
		CGContextSetLineWidth(context, 1.0f);
		CGContextMoveToPoint(context, point.x - 5.0, point.y + 1.0);
		CGContextAddLineToPoint(context, rect.size.width + 5.0, point.y + 1.0);
		CGContextStrokePath(context);
		
		CGPoint topPoint = point;
		CGFloat barHeight;
		CGFloat barPosition;
		CGFloat barWidth = (rect.size.width - 20.0) / 13.0;
		
		double colorIncrement = 0.9 / [dataPanel.dataSet.dataItems count];
		
		barWidth += barWidth * 0.25 / 30;
		point.y += 2.0;
		
		NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
		NSArray *sortedItems = [dataPanel.dataSet.dataItems sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		NSDateComponents *interval = [[NSDateComponents alloc] init];
		
		[interval setMonth:-12];
		[dateFormatter setDateFormat:@"MMM"];
		
		NSDate *startDate = [[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:[NSDate date] options:0];
		
		CGSize dateSize;
		CGFloat dateOffset = 0.0;
		
		for (NSUInteger i = 0; i < 13; i++) {
			[interval setMonth:i];
			
			dateSize = [[[dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:startDate options:0]] uppercaseString] drawAtPoint:CGPointMake(point.x + dateOffset, point.y) forWidth:rect.size.width - 60.0 withFont:tinyFont lineBreakMode:UILineBreakModeTailTruncation];
			
			dateOffset += dateSize.width + 4.8;
		}
		
		[dateFormatter release];
		
		point.y += 20.0;
		
		CGContextSetRGBStrokeColor(context, 0.88, 0.88, 0.88, 1.0);
		
		NSMutableArray *monthTotals = [[NSMutableArray alloc] init];
		
		for (NSUInteger i = 0; i < 30; i++) {
			[interval setMonth:i];
			[monthTotals addObject:[NSNumber numberWithDouble:[dataPanel.dataSet totalForMonth:[[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:startDate options:0]]]];
		}
		
		sorter = [[[NSSortDescriptor alloc] initWithKey:@"doubleValue" ascending:NO] autorelease];
		double largestMonthTotal = [[[monthTotals sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]] objectAtIndex:0] doubleValue];
		
		for (NSUInteger i = 0; i < 30; i++) {
			if ([[monthTotals objectAtIndex:i] doubleValue] > 0) {
				counter = 0;
				barPosition = 0.0;
				
				[interval setMonth:i];
				
				for (DataItem *dataItem in sortedItems) {
					barHeight = 196.0 * [dataItem totalForMonth:[[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:startDate options:0]] / largestMonthTotal;
					
					if (barHeight > 0.0) {
						CGRect rect = CGRectMake(topPoint.x, topPoint.y - barHeight - barPosition, barWidth * 0.75, barHeight);
						
						CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] CGColor]);
						CGContextFillRect(context, rect);
						CGContextStrokeRect(context, rect);
						
						barPosition += barHeight;
					}
					
					counter++;
				}
			}
			
			topPoint.x += barWidth;
		}
		
		[monthTotals release];
		[interval release];
		
		counter = 0;
		
		CGSize totalSize;
		NSString *totalText;
		
		for (DataItem *dataItem in sortedItems) {
			point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
			
			[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
			
			CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
			CGContextFillPath(context);
			
			[textColor set];
			
			totalText = [NSString stringWithFormat:@"%1.2f", dataItem.total];
			totalSize = [totalText sizeWithFont:smallFont forWidth:40.0 lineBreakMode:UILineBreakModeTailTruncation];
			textSize = [[dataItem.name uppercaseString] drawAtPoint:CGPointMake(point.x + 20.0, point.y) forWidth:(rect.size.width - 20.0) / 2 - totalSize.width - 30.0 withFont:mediumFont lineBreakMode:UILineBreakModeTailTruncation];
			
			[[textColor colorWithAlphaComponent:0.5] set];
			
			[totalText drawAtPoint:CGPointMake(point.x + textSize.width + 24.0, point.y + 3.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
			
			if (counter % 2 > 0) point.y += textSize.height + 5.0;
			
			counter++;
		}
	}
	
	return image;
}

@end
