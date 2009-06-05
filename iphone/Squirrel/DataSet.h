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
	
	float total;
	
	BOOL hydrated;
	BOOL dirty;
	BOOL related;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (assign, nonatomic, readonly) float total;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSDate *lastUpdated;
@property (retain, nonatomic) NSMutableArray *dataItems;

+ (void)finalizeStatements;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)insertIntoDatabase:(sqlite3 *)database;

- (void)save;
- (void)hydrate;
- (void)dehydrate;
- (void)deleteFromDatabase;
- (void)selectRelated;

- (void)addDataItem:(DataItem *)dataItem;
- (void)removeDataItem:(DataItem *)dataItem;

@end
