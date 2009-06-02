//
//  DataItem.h
//  Squirrel
//
//  Created by Taylan Pince on 31/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataSet, DataEntry;

@interface DataItem : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSString *name;
	DataSet *dataSet;
	NSMutableArray *dataEntries;
	
	BOOL hydrated;
	BOOL dirty;
	BOOL related;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) DataSet *dataSet;
@property (retain, nonatomic) NSMutableArray *dataEntries;

+ (void)finalizeStatements;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)insertIntoDatabase:(sqlite3 *)database;

- (void)hydrate;
- (void)dehydrate;
- (void)deleteFromDatabase;
- (void)selectRelated;

- (void)addDataEntry:(DataEntry *)dataEntry;
- (void)removeDataEntry:(DataEntry *)dataEntry;

@end
