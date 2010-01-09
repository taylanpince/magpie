//
//  StatOperation.m
//  Magpie
//
//  Created by Taylan Pince on 09-12-22.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "StatOperation.h"
#import "PanelColor.h"
#import "Category.h"
#import "Display.h"
#import "Entry.h"
#import "Item.h"


@implementation StatOperation

@synthesize display, cellIndex, statImage, delegate;

- (id)initWithDisplay:(Display *)aDisplay index:(NSUInteger)aCellIndex {
	if (self = [super init]) {
		display = [aDisplay retain];
		cellIndex = aCellIndex;
	}
	
	return self;
}

- (void)dealloc {
	[display release];
	[statImage release];
	[super dealloc];
}

- (void)main {
	if (!self.isCancelled) {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		CGRect rect = CGRectMake(10.0, 0.0, [[UIScreen mainScreen] applicationFrame].size.width, [display heightForDisplay]);
		CGColorSpaceRef	colorSpace = CGColorSpaceCreateDeviceRGB();
		CGBitmapInfo alphaInfo = (kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host);
		CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, alphaInfo);
		CGImageRef cgImage = NULL;
		
		UIColor *panelColor = [PanelColor colorWithName:display.color alpha:1.0];
		UIColor *textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
		
		UIFont *largeFont = [UIFont boldSystemFontOfSize:24];
		UIFont *mainFont = [UIFont boldSystemFontOfSize:18];
		UIFont *mediumFont = [UIFont boldSystemFontOfSize:15];
		UIFont *smallFont = [UIFont systemFontOfSize:12];
		UIFont *tinyFont = [UIFont systemFontOfSize:8];
		
		CGPoint point = CGPointMake(rect.origin.x + 10.0, rect.origin.y + 50.0);
		CGSize textSize;
		
		int counter = 0;
		
		if ([display.type isEqualToString:@"Horizontal Bar Chart"]) {
			for (Item *item in display.category.items) {
				[textColor set];
				
				textSize = [[item.name uppercaseString] drawAtPoint:point forWidth:rect.size.width - 100.0 withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
				
				[[textColor colorWithAlphaComponent:0.5] set];
				
				[[NSString stringWithFormat:@"%1.2f", item.total] drawAtPoint:CGPointMake(point.x + textSize.width + 6.0, point.y + 5.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
				
				point.y += textSize.height;
				
				[[panelColor colorWithAlphaComponent:0.5] set];
				
				CGContextAddRect(context, CGRectMake(point.x, point.y, rect.size.width - 20.0, 10.0));
				CGContextFillPath(context);
				
				[panelColor set];
				
				CGContextAddRect(context, CGRectMake(point.x, point.y, ((rect.size.width - 20.0) * item.percentage / 100.0), 10.0));
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
			NSArray *sortedItems = [[display.category.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
			Item *topItem = [sortedItems objectAtIndex:0];
			
			for (Item *item in sortedItems) {
				[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
				
				if (item.percentage > 0.0) {
					barHeight = 196.0 * item.percentage / topItem.percentage;
					
					CGContextAddRect(context, CGRectMake(topPoint.x, topPoint.y - barHeight, barWidth * 0.75, barHeight));
					CGContextFillPath(context);
					
					topPoint.x += barWidth;
				}
				
				point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
				
				CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
				CGContextFillPath(context);
				
				[textColor set];
				
				totalText = [NSString stringWithFormat:@"%1.2f", item.total];
				totalSize = [totalText sizeWithFont:smallFont forWidth:40.0 lineBreakMode:UILineBreakModeTailTruncation];
				textSize = [[item.name uppercaseString] drawAtPoint:CGPointMake(point.x + 20.0, point.y) forWidth:(rect.size.width - 20.0) / 2 - totalSize.width - 30.0 withFont:mediumFont lineBreakMode:UILineBreakModeTailTruncation];
				
				[[textColor colorWithAlphaComponent:0.5] set];
				
				[totalText drawAtPoint:CGPointMake(point.x + textSize.width + 24.0, point.y + 3.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
				
				if (counter % 2 > 0) point.y += textSize.height + 5.0;
				
				counter++;
			}
		} else if ([display.type isEqualToString:@"Pie Chart"]) {
			double totalPercentage = 0.0;
			double colorIncrement = 0.9 / [display.category.items count];
			
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
			NSArray *sortedItems = [[display.category.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
			
			CGSize totalSize;
			NSString *totalText;
			
			for (Item *item in sortedItems) {
				if (item.percentage > 0.0) {
					CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
					CGContextSetLineWidth(context, 1.0f);
					
					startAngle = ((360.0 * totalPercentage / 100.0) - 5.0) * (M_PI / 180.0);
					endAngle = startAngle + ((360.0 * item.percentage / 100.0) * (M_PI / 180.0));
					
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
					
					totalPercentage += item.percentage;
				}
				
				point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
				
				[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
				
				CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
				CGContextFillPath(context);
				
				[textColor set];
				
				totalText = [NSString stringWithFormat:@"%1.2f", item.total];
				totalSize = [totalText sizeWithFont:smallFont forWidth:40.0 lineBreakMode:UILineBreakModeTailTruncation];
				textSize = [[item.name uppercaseString] drawAtPoint:CGPointMake(point.x + 20.0, point.y) forWidth:(rect.size.width - 20.0) / 2 - totalSize.width - 30.0 withFont:mediumFont lineBreakMode:UILineBreakModeTailTruncation];
				
				[[textColor colorWithAlphaComponent:0.5] set];
				
				[totalText drawAtPoint:CGPointMake(point.x + textSize.width + 24.0, point.y + 3.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
				
				if (counter % 2 > 0) point.y += textSize.height + 5.0;
				
				counter++;
			}
		} else if ([display.type isEqualToString:@"Latest Entry as Words"] || [display.type isEqualToString:@"Largest Entry as Words"]) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			
			[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
			
			NSNumber *numberValue;
			
			if ([display.type isEqualToString:@"Latest Entry as Words"]) {
				numberValue = [[[display.category latestItem] latestEntry] value];
			} else if ([display.type isEqualToString:@"Largest Entry as Words"]) {
				numberValue = [[display.category largestEntry] value];
			}
			
			textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
			
			point.y += textSize.height + 6.0;
			
			[numberFormatter release];
		} else if ([display.type isEqualToString:@"Latest Entry as Numbers"] || [display.type isEqualToString:@"Largest Entry as Numbers"]) {
			NSNumber *numberValue;
			
			if ([display.type isEqualToString:@"Latest Entry as Numbers"]) {
				numberValue = [[[display.category latestItem] latestEntry] value];
			} else if ([display.type isEqualToString:@"Largest Entry as Numbers"]) {
				numberValue = [[display.category largestEntry] value];
			}
			
			textSize = [[[numberValue stringValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
			
			point.y += textSize.height + 6.0;
		} else if ([display.type isEqualToString:@"Latest Entry Type"] || [display.type isEqualToString:@"Largest Entry Type"]) {
			NSString *entryName;
			
			if ([display.type isEqualToString:@"Latest Entry Type"]) {
				entryName = [[display.category latestItem] name];
			} else if ([display.type isEqualToString:@"Largest Entry Type"]) {
				entryName = [[display.category largestItem] name];
			}
			
			textSize = [[entryName uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:mainFont lineBreakMode:UILineBreakModeWordWrap];
			
			point.y += textSize.height + 6.0;
		} else if ([display.type isEqualToString:@"Total as Numbers"] || [display.type isEqualToString:@"Average Entry as Numbers"]) {
			NSNumber *numberValue;
			
			if ([display.type isEqualToString:@"Total as Numbers"]) {
				numberValue = [NSNumber numberWithDouble:display.category.total];
			} else if ([display.type isEqualToString:@"Average Entry as Numbers"]) {
				numberValue = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%1.2f", [display.category averageEntryValue]] doubleValue]];
			}
			
			textSize = [[[numberValue stringValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
			
			point.y += textSize.height + 6.0;
		} else if ([display.type isEqualToString:@"Total as Words"] || [display.type isEqualToString:@"Average Entry as Words"]) {
			NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
			NSNumber *numberValue;
			
			if ([display.type isEqualToString:@"Total as Words"]) {
				numberValue = [NSNumber numberWithDouble:display.category.total];
			} else if ([display.type isEqualToString:@"Average Entry as Words"]) {
				numberValue = [NSNumber numberWithDouble:[[NSString stringWithFormat:@"%1.2f", [display.category averageEntryValue]] doubleValue]];
			}
			
			[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
			
			textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] drawInRect:CGRectMake(point.x, point.y, rect.size.width - 20.0, 600.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
			
			point.y += textSize.height + 6.0;
			
			[numberFormatter release];
		} else if ([display.type isEqualToString:@"Daily Timeline"]) {
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
			
			double colorIncrement = 0.9 / [display.category.items count];
			
			barWidth += barWidth * 0.25 / 30;
			point.y += 2.0;
			
			NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
			NSArray *sortedItems = [[display.category.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
			
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
				[dayTotals addObject:[NSNumber numberWithDouble:[display.category totalForDay:[startDate addTimeInterval:i * 60 * 60 * 24]]]];
			}
			
			sorter = [[[NSSortDescriptor alloc] initWithKey:@"doubleValue" ascending:NO] autorelease];
			double largestDayTotal = [[[dayTotals sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]] objectAtIndex:0] doubleValue];
			
			for (NSUInteger i = 0; i < 30; i++) {
				if ([[dayTotals objectAtIndex:i] doubleValue] > 0) {
					counter = 0;
					barPosition = 0.0;
					
					for (Item *item in sortedItems) {
						barHeight = 196.0 * [item totalForDay:[startDate addTimeInterval:i * 60 * 60 * 24]] / largestDayTotal;
						
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
			
			for (Item *item in sortedItems) {
				point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
				
				[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
				
				CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
				CGContextFillPath(context);
				
				[textColor set];
				
				totalText = [NSString stringWithFormat:@"%1.2f", item.total];
				totalSize = [totalText sizeWithFont:smallFont forWidth:40.0 lineBreakMode:UILineBreakModeTailTruncation];
				textSize = [[item.name uppercaseString] drawAtPoint:CGPointMake(point.x + 20.0, point.y) forWidth:(rect.size.width - 20.0) / 2 - totalSize.width - 30.0 withFont:mediumFont lineBreakMode:UILineBreakModeTailTruncation];
				
				[[textColor colorWithAlphaComponent:0.5] set];
				
				[totalText drawAtPoint:CGPointMake(point.x + textSize.width + 24.0, point.y + 3.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
				
				if (counter % 2 > 0) point.y += textSize.height + 5.0;
				
				counter++;
			}
		} else if ([display.type isEqualToString:@"Monthly Timeline"]) {
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
			
			double colorIncrement = 0.9 / [display.category.items count];
			
			barWidth += barWidth * 0.25 / 30;
			point.y += 2.0;
			
			NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
			NSArray *sortedItems = [[display.category.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
			
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
				[monthTotals addObject:[NSNumber numberWithDouble:[display.category totalForMonth:[[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:startDate options:0]]]];
			}
			
			sorter = [[[NSSortDescriptor alloc] initWithKey:@"doubleValue" ascending:NO] autorelease];
			double largestMonthTotal = [[[monthTotals sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]] objectAtIndex:0] doubleValue];
			
			for (NSUInteger i = 0; i < 30; i++) {
				if ([[monthTotals objectAtIndex:i] doubleValue] > 0) {
					counter = 0;
					barPosition = 0.0;
					
					[interval setMonth:i];
					
					for (Item *item in sortedItems) {
						barHeight = 196.0 * [item totalForMonth:[[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:startDate options:0]] / largestMonthTotal;
						
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
			
			for (Item *item in sortedItems) {
				point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
				
				[[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] set];
				
				CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
				CGContextFillPath(context);
				
				[textColor set];
				
				totalText = [NSString stringWithFormat:@"%1.2f", item.total];
				totalSize = [totalText sizeWithFont:smallFont forWidth:40.0 lineBreakMode:UILineBreakModeTailTruncation];
				textSize = [[item.name uppercaseString] drawAtPoint:CGPointMake(point.x + 20.0, point.y) forWidth:(rect.size.width - 20.0) / 2 - totalSize.width - 30.0 withFont:mediumFont lineBreakMode:UILineBreakModeTailTruncation];
				
				[[textColor colorWithAlphaComponent:0.5] set];
				
				[totalText drawAtPoint:CGPointMake(point.x + textSize.width + 24.0, point.y + 3.0) forWidth:40.0 withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
				
				if (counter % 2 > 0) point.y += textSize.height + 5.0;
				
				counter++;
			}
		}
		
		if (!self.isCancelled) {
			cgImage = CGBitmapContextCreateImage(context);
		}
		
		CGContextRelease(context);
		
		if (cgImage) {
			if (!self.isCancelled) {
				statImage = [[UIImage alloc] initWithCGImage:cgImage];
			}
			
			CGImageRelease(cgImage);
		}
		
		[pool drain];
		
		if (!self.isCancelled && delegate) {
			[delegate statOperationComplete:self];
		}
	}
}

@end
