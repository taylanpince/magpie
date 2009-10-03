//
//  Category.h
//  Magpie
//
//  Created by Taylan Pince on 09-10-03.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Display;
@class Item;

@interface Category :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSSet* displays;
@property (nonatomic, retain) NSSet* items;

@end


@interface Category (CoreDataGeneratedAccessors)
- (void)addDisplaysObject:(Display *)value;
- (void)removeDisplaysObject:(Display *)value;
- (void)addDisplays:(NSSet *)value;
- (void)removeDisplays:(NSSet *)value;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end

