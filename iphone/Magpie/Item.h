//
//  Item.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Category;
@class Entry;

@interface Item :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSSet* entries;
@property (nonatomic, retain) Category * category;

@end


@interface Item (CoreDataGeneratedAccessors)
- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)value;
- (void)removeEntries:(NSSet *)value;

@end

