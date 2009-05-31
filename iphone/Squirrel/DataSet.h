//
//  DataSet.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataItem;

@interface DataSet : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSString *name;
	NSDate *lastUpdated;
	NSMutableArray *dataItems;
	
	BOOL hydrated;
	BOOL dirty;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSDate *lastUpdated;
@property (retain, nonatomic) NSMutableArray *dataItems;

+ (void)finalizeStatements;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)insertIntoDatabase:(sqlite3 *)database;

- (void)hydrate;
- (void)dehydrate;
- (void)deleteFromDatabase;

- (void)addDataItem:(DataItem *)dataItem;
- (void)removeDataItem:(DataItem *)dataItem;

@end