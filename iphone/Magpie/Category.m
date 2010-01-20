// 
//  Category.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "Category.h"
#import "Display.h"
#import "Item.h"


@implementation Category 

@dynamic name;
@dynamic lastUpdated;
@dynamic displays;
@dynamic items;

- (double)total {
	total = 0.0;
	
	for (Item *item in self.items) {
		total += item.total;
	}
	
	return total;
}

- (Item *)latestItem {
	NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:YES] autorelease];
	NSArray *sortedItems = [[self.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
	
	return [sortedItems lastObject];
}

- (Item *)largestItem {
	NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"total" ascending:YES] autorelease];
	NSArray *sortedItems = [[self.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
	
	return [sortedItems lastObject];
}

- (Entry *)largestEntry {
	NSMutableArray *largestDataEntries = [NSMutableArray arrayWithCapacity:[self.items count]];
	
	for (Item *item in self.items) {
		[largestDataEntries addObject:[item largestEntry]];
	}
	
	NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES] autorelease];
	NSArray *sortedItems = [largestDataEntries sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
	
	return [sortedItems lastObject];
}

- (double)totalForDay:(NSDate *)day {
	double total_value = 0.0;
	
	for (Item *item in self.items) {
		total_value += [item totalForDay:day];
	}
	
	return total_value;
}

- (double)totalForMonth:(NSDate *)month {
	double total_value = 0.0;
	
	for (Item *item in self.items) {
		total_value += [item totalForMonth:month];
	}
	
	return total_value;
}

- (double)averageEntryValue {
	double averageTotal = 0.0;
	
	for (Item *item in self.items) {
		averageTotal += [item averageEntryValue];
	}
	
	return averageTotal / [self.items count];
}

- (NSArray *)itemsByLastUpdated {
	NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdated" ascending:NO] autorelease];
	NSArray *sortedItems = [[self.items allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
	
	return sortedItems;
}

@end