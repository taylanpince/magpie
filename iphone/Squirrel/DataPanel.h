//
//  DataPanel.h
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataSet;

@interface DataPanel : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSString *name;
	NSString *type;
	NSString *color;
	NSNumber *weight;
	DataSet *dataSet;
	
	BOOL hydrated;
	BOOL dirty;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *color;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSNumber *weight;
@property (copy, nonatomic) DataSet *dataSet;

+ (void)finalizeStatements;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)insertIntoDatabase:(sqlite3 *)database;

- (void)hydrate;
- (void)forceHydrate;
- (void)dehydrate;
- (void)deleteFromDatabase;

@end
