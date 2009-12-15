// 
//  Item.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "Item.h"
#import "Category.h"
#import "Entry.h"


@implementation Item 

@dynamic name;
@dynamic lastUpdated;
@dynamic entries;
@dynamic category;

- (double)total {
	total = 0.0;
	
	for (Entry *entry in self.entries) {
		total += [entry.value doubleValue];
	}
	
	return total;
}

- (double)percentage {
	return 100 * self.total / self.category.total;
}

- (Entry *)latestEntry {
	NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES] autorelease];
	NSArray *sortedItems = [[self.entries allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
	
	return [sortedItems lastObject];
}

- (Entry *)largestEntry {
	NSSortDescriptor *sorter = [[[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES] autorelease];
	NSArray *sortedItems = [[self.entries allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
	
	return [sortedItems lastObject];
}

- (double)totalForDay:(NSDate *)day {
	double total_value = 0.0;
	
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:day];
	NSDateComponents *interval = [[NSDateComponents alloc] init];
	
	[interval setDay:1];
	
	NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
	NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:startDate options:0];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp between {%@, %@}", startDate, endDate];
	
	for (Entry *entry in [self.entries filteredSetUsingPredicate:predicate]) {
		total_value += [entry.value doubleValue];
	}
	
	[interval release];
	
	return total_value;
}

- (double)totalForMonth:(NSDate *)month {
	double total_value = 0.0;
	
	NSDateComponents *comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:month];
	NSDateComponents *interval = [[NSDateComponents alloc] init];
	
	[interval setMonth:1];
	
	NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
	NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:interval toDate:startDate options:0];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp between {%@, %@}", startDate, endDate];
	
	for (Entry *entry in [self.entries filteredSetUsingPredicate:predicate]) {
		total_value += [entry.value doubleValue];
	}
	
	[interval release];
	
	return total_value;
}

- (double)averageEntryValue {
	return self.total / [self.entries count];
}

@end