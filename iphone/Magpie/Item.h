//
//  Item.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Category;
@class Entry;

@interface Item : NSManagedObject {
	double total;
	double percentage;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *lastUpdated;
@property (nonatomic, retain) NSSet *entries;
@property (nonatomic, retain) Category *category;

@property (nonatomic, assign, readonly) double total;
@property (nonatomic, assign, readonly) double percentage;

@end

@interface Item (CoreDataGeneratedAccessors)
- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)value;
- (void)removeEntries:(NSSet *)value;

- (Entry *)latestEntry;
- (Entry *)largestEntry;

- (double)totalForDay:(NSDate *)day;
- (double)totalForMonth:(NSDate *)month;
- (double)averageEntryValue;
@end