//
//  DataEntry.h
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataItem;


@interface DataEntry : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSNumber *value;
	NSDate *timeStamp;
	DataItem *dataItem;

	BOOL hydrated;
	BOOL dirty;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSNumber *value;
@property (copy, nonatomic) NSDate *timeStamp;
@property (copy, nonatomic) DataItem *dataItem;

+ (void)finalizeStatements;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)insertIntoDatabase:(sqlite3 *)database;

- (void)hydrate;
- (void)dehydrate;
- (void)deleteFromDatabase;

@end
