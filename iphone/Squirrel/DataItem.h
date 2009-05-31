//
//  DataItem.h
//  Squirrel
//
//  Created by Taylan Pince on 31/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataSet;

@interface DataItem : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSString *name;
	DataSet *dataSet;
	
	BOOL hydrated;
	BOOL dirty;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) DataSet *dataSet;

+ (void)finalizeStatements;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)insertIntoDatabase:(sqlite3 *)database;

- (void)hydrate;
- (void)dehydrate;
- (void)deleteFromDatabase;

@end
