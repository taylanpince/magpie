// 
//  Display.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "Display.h"

#import "Category.h"
#import "Item.h"
#import "Entry.h"

@implementation Display 

@dynamic weight;
@dynamic name;
@dynamic type;
@dynamic color;
@dynamic category;

@synthesize hasImage, hasQueuedOperation;

- (CGFloat)heightForDisplay {
	CGFloat height = 10.0;
	CGFloat width = [[UIScreen mainScreen] applicationFrame].size.width - 40.0;
	
	UIFont *largeFont = [UIFont boldSystemFontOfSize:24];
	UIFont *mainFont = [UIFont boldSystemFontOfSize:18];
	
	if ([self.type isEqualToString:@"Horizontal Bar Chart"]) {
		height = 70.0 + [self.category.items count] * 40.0;
	} else if ([self.type isEqualToString:@"Pie Chart"] || [self.type isEqualToString:@"Vertical Bar Chart"]) {
		height = 280.0 + ceil([self.category.items count] / 2.0) * 24.0;
	} else if ([self.type isEqualToString:@"Latest Entry as Words"] || [self.type isEqualToString:@"Largest Entry as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		NSNumber *numberValue;
		
		if ([self.type isEqualToString:@"Latest Entry as Words"]) {
			numberValue = [[[self.category latestItem] latestEntry] value];
		} else if ([self.type isEqualToString:@"Largest Entry as Words"]) {
			numberValue = [[self.category largestEntry] value];
		}
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		CGSize textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
		
		[numberFormatter release];
	} else if ([self.type isEqualToString:@"Latest Entry as Numbers"] || [self.type isEqualToString:@"Largest Entry as Numbers"]) {
		NSNumber *numberValue;
		
		if ([self.type isEqualToString:@"Latest Entry as Words"]) {
			numberValue = [[[self.category latestItem] latestEntry] value];
		} else if ([self.type isEqualToString:@"Largest Entry as Numbers"]) {
			numberValue = [[self.category largestEntry] value];
		}
		
		CGSize textSize = [[[numberValue stringValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
	} else if ([self.type isEqualToString:@"Latest Entry Type"] || [self.type isEqualToString:@"Largest Entry Type"]) {
		NSString *entryName;
		
		if ([self.type isEqualToString:@"Latest Entry Type"]) {
			entryName = [[self.category latestItem] name];
		} else if ([self.type isEqualToString:@"Largest Entry Type"]) {
			entryName = [[self.category largestItem] name];
		}
		
		CGSize textSize = [[entryName uppercaseString] sizeWithFont:mainFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
	} else if ([self.type isEqualToString:@"Total as Words"] || [self.type isEqualToString:@"Average Entry as Words"]) {
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		NSNumber *numberValue;
		
		if ([self.type isEqualToString:@"Total as Words"]) {
			numberValue = [NSNumber numberWithDouble:[self.category total]];
		} else if ([self.type isEqualToString:@"Average Entry as Words"]) {
			numberValue = [NSNumber numberWithDouble:[self.category averageEntryValue]];
		}
		
		[numberFormatter setNumberStyle:NSNumberFormatterSpellOutStyle];
		
		CGSize textSize = [[[numberFormatter stringFromNumber:numberValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
		
		[numberFormatter release];
	} else if ([self.type isEqualToString:@"Total as Numbers"] || [self.type isEqualToString:@"Average Entry as Numbers"]) {
		NSNumber *numberValue;
		
		if ([self.type isEqualToString:@"Total as Numbers"]) {
			numberValue = [NSNumber numberWithDouble:[self.category total]];
		} else if ([self.type isEqualToString:@"Average Entry as Numbers"]) {
			numberValue = [NSNumber numberWithDouble:[self.category averageEntryValue]];
		}
		
		CGSize textSize = [[[numberValue stringValue] uppercaseString] sizeWithFont:largeFont constrainedToSize:CGSizeMake(width, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		height = 70.0 + textSize.height;
	} else if ([self.type isEqualToString:@"Daily Timeline"] || [self.type isEqualToString:@"Monthly Timeline"]) {
		height = 288.0 + ceil([self.category.items count] / 2.0) * 24.0;
	}
	
	return height + 10.0;
}

@end