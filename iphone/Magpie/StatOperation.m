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
		
		CGRect rect = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] applicationFrame].size.width, [display heightForDisplay]);
		CGColorSpaceRef	colorSpace = CGColorSpaceCreateDeviceRGB();
		CGBitmapInfo alphaInfo = (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
		CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, alphaInfo);
		CGImageRef cgImage = NULL;
		
		UIColor *panelColor = [PanelColor colorWithName:display.color alpha:1.0];
		/*UIColor *textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];*/
		
		int corner_radius = 10;
		int header_height = 40;
		
		CGContextTranslateCTM(context, 0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0 );
		CGContextSetPatternPhase(context, CGSizeMake(0, rect.size.height));
		
		rect.size.width -= 20.0;
		rect.size.height -= 24.0;
		rect.origin.x += 10.0;
		rect.origin.y += 10.0;
		
		if (!self.isCancelled) {
			CGContextSaveGState(context);
			CGContextSetShadow(context, CGSizeMake(2.0, -8.0), 4.0);
			CGContextSetRGBFillColor(context, 0.88, 0.88, 0.88, 1.0);
			
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
		}
		
		if (!self.isCancelled) {
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
			
			CGContextSetFillColorWithColor(context, [panelColor CGColor]);
			CGContextAddRect(context, CGRectMake(0.0, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + header_height));
			CGContextFillPath(context);
		}
		
		if (!self.isCancelled) {
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
			
			CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
			
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
		}
		
		if (!self.isCancelled) {
			size_t bottom_locations_num = 2;
			CGFloat bottom_locations[2] = {
				0.0,
				1.0
			};
			
			CGFloat bottom_components[16] = {
				0.88, 0.88, 0.88, 1.0,
				0.6, 0.6, 0.6, 1.0
			};
			
			CGGradientRef bottom_gradient = CGGradientCreateWithColorComponents(colorSpace, bottom_components, bottom_locations, bottom_locations_num);
			
			CGContextDrawLinearGradient(context, bottom_gradient, CGPointMake(0.0, rect.origin.y + rect.size.height - 6.0), CGPointMake(0.0, rect.origin.y + rect.size.height), 0);
			CGGradientRelease(bottom_gradient);
		}
		
		CGPoint point = CGPointMake(rect.origin.x + 10.0, rect.origin.y + 50.0);
		
		int counter = 0;
		
		if ([display.type isEqualToString:@"Horizontal Bar Chart"] && !self.isCancelled) {
			for (Item *item in display.category.items) {
				point.y += 20.0;
				
				CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.5] CGColor]);
				CGContextAddRect(context, CGRectMake(point.x, point.y, rect.size.width - 20.0, 10.0));
				CGContextFillPath(context);
				
				CGContextSetFillColorWithColor(context, [panelColor CGColor]);
				CGContextAddRect(context, CGRectMake(point.x, point.y, ((rect.size.width - 20.0) * item.percentage / 100.0), 10.0));
				CGContextFillPath(context);
				
				point.y += 18.0;
				
				counter++;
			}
		} else if ([display.type isEqualToString:@"Vertical Bar Chart"] && !self.isCancelled) {
			point.y += 200.0;
			
			CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
			CGContextSetLineWidth(context, 1.0f);
			CGContextMoveToPoint(context, point.x - 5.0, point.y + 1.0);
			CGContextAddLineToPoint(context, rect.size.width + 5.0, point.y + 1.0);
			CGContextStrokePath(context);
			
			CGPoint topPoint = point;
			CGFloat barHeight;
			CGFloat barWidth = (rect.size.width - 20.0) / [display.category.items count];
			
			double colorIncrement = 0.9 / [display.category.items count];
			
			barWidth += barWidth * 0.25 / [display.category.items count];
			point.y += 12.0;
			
			NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
			NSArray *sortedItems = [[display.category.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
			Item *topItem = [sortedItems objectAtIndex:0];
			
			for (Item *item in sortedItems) {
				CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] CGColor]);
				
				if (item.percentage > 0.0) {
					barHeight = 196.0 * item.percentage / topItem.percentage;
					
					CGContextAddRect(context, CGRectMake(topPoint.x, topPoint.y - barHeight, barWidth * 0.75, barHeight));
					CGContextFillPath(context);
					
					topPoint.x += barWidth;
				}
				
				point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
				
				CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
				CGContextFillPath(context);
				
				if (counter % 2 > 0) point.y += 24.0;
				
				counter++;
			}
		} else if ([display.type isEqualToString:@"Pie Chart"] && !self.isCancelled) {
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
				
				CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] CGColor]);
				CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
				CGContextFillPath(context);
				
				if (counter % 2 > 0) point.y += 24.0;
				
				counter++;
			}
		} else if ([display.type isEqualToString:@"Daily Timeline"] && !self.isCancelled) {
			point.y += 200.0;
			
			CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
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
			point.y += 22.0;
			
			NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
			NSArray *sortedItems = [[display.category.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
			NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-1 * 60 * 60 * 24 * 29];
			
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
			
			for (Item *item in sortedItems) {
				point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
				
				CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] CGColor]);
				CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
				CGContextFillPath(context);
				
				if (counter % 2 > 0) point.y += 24.0;
				
				counter++;
			}
		} else if ([display.type isEqualToString:@"Monthly Timeline"] && !self.isCancelled) {
			point.y += 200.0;
			
			CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
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
			point.y += 22.0;
			
			NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:NO] autorelease];
			NSArray *sortedItems = [[display.category.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
			NSDateComponents *interval = [[NSDateComponents alloc] init];
			
			[interval setMonth:-12];
			
			NSDate *startDate = [[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:[NSDate date] options:0];
			
			CGContextSetRGBStrokeColor(context, 0.88, 0.88, 0.88, 1.0);
			
			NSMutableArray *monthTotals = [[NSMutableArray alloc] init];
			
			for (NSUInteger i = 0; i < 13; i++) {
				[interval setMonth:i];
				[monthTotals addObject:[NSNumber numberWithDouble:[display.category totalForMonth:[[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:startDate options:0]]]];
			}
			
			sorter = [[[NSSortDescriptor alloc] initWithKey:@"doubleValue" ascending:NO] autorelease];
			double largestMonthTotal = [[[monthTotals sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]] objectAtIndex:0] doubleValue];
			
			for (NSUInteger i = 0; i < 13; i++) {
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
			
			for (Item *item in sortedItems) {
				point.x = (counter % 2 == 0) ? rect.origin.x + 10.0 : point.x + (rect.size.width - 20.0) / 2;
				
				CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:1.0 - (colorIncrement * counter)] CGColor]);
				CGContextFillRect(context, CGRectMake(point.x, point.y + 2.5, 15.0, 15.0));
				CGContextFillPath(context);
				
				if (counter % 2 > 0) point.y += 24.0;
				
				counter++;
			}
		}
		
		if (!self.isCancelled) {
			cgImage = CGBitmapContextCreateImage(context);
		}
		
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
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
