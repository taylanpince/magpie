// 
//  DataSet.m
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "DataSet.h"
#import "DataItem.h"
#import "DataPanel.h"

static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *delete_statement = nil;
static sqlite3_stmt *hydrate_statement = nil;
static sqlite3_stmt *dehydrate_statement = nil;
static sqlite3_stmt *select_related_statement = nil;

@implementation DataSet

@synthesize dataItems;

+ (void)finalizeStatements {
    if (insert_statement) {
        sqlite3_finalize(insert_statement);
        insert_statement = nil;
    }

    if (init_statement) {
        sqlite3_finalize(init_statement);
        init_statement = nil;
    }
    
	if (delete_statement) {
        sqlite3_finalize(delete_statement);
        delete_statement = nil;
    }
    
	if (hydrate_statement) {
        sqlite3_finalize(hydrate_statement);
        hydrate_statement = nil;
    }
    
	if (dehydrate_statement) {
        sqlite3_finalize(dehydrate_statement);
        dehydrate_statement = nil;
    }
    
	if (select_related_statement) {
        sqlite3_finalize(select_related_statement);
        select_related_statement = nil;
    }
}


- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
    if (self = [super init]) {
        primaryKey = pk;
        database = db;

        if (init_statement == nil) {
            const char *sql = "SELECT name, last_updated FROM data_sets WHERE pk=?";

            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }

        sqlite3_bind_int(init_statement, 1, primaryKey);
        
		if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
			self.lastUpdated = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(init_statement, 1)];
        } else {
            self.name = @"No name";
			self.lastUpdated = [NSDate date];
        }

        sqlite3_reset(init_statement);
        dirty = NO;
    }
	
    return self;
}


- (void)insertIntoDatabase:(sqlite3 *)db {
    database = db;

    if (insert_statement == nil) {
        static char *sql = "INSERT INTO data_sets (name,last_updated) VALUES(?,?)";

        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }

    sqlite3_bind_text(insert_statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_double(insert_statement, 2, [lastUpdated timeIntervalSince1970]);

    int success = sqlite3_step(insert_statement);

    sqlite3_reset(insert_statement);
    
	if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    } else {
        primaryKey = sqlite3_last_insert_rowid(database);
    }

    hydrated = YES;
}

- (void)dealloc {
    [name release];
	[lastUpdated release];
	[dataItems release];
    [super dealloc];
}

- (void)deleteFromDatabase {
    if (delete_statement == nil) {
        const char *sql = "DELETE FROM data_sets WHERE pk=?";

        if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }

    sqlite3_bind_int(delete_statement, 1, primaryKey);

    int success = sqlite3_step(delete_statement);

    sqlite3_reset(delete_statement);

    if (success != SQLITE_DONE) {
        NSAssert1(0, @"Error: failed to delete from database with message '%s'.", sqlite3_errmsg(database));
    }
	
	if (select_related_statement == nil) {
		const char *sql = "SELECT pk FROM data_items WHERE data_set=?";
		
		if (sqlite3_prepare_v2(database, sql, -1, &select_related_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	sqlite3_bind_int(select_related_statement, 1, primaryKey);
	
	while (sqlite3_step(select_related_statement) == SQLITE_ROW) {
		int itemPrimaryKey = sqlite3_column_int(select_related_statement, 0);
		
		DataItem *dataItem = [[DataItem alloc] initWithPrimaryKey:itemPrimaryKey database:database];
		[dataItem deleteFromDatabase];
		[dataItem release];
	}
	
	sqlite3_reset(select_related_statement);
}


- (void)hydrate {
    if (hydrated) return;

    if (hydrate_statement == nil) {
        const char *sql = "SELECT last_updated FROM data_sets WHERE pk=?";

        if (sqlite3_prepare_v2(database, sql, -1, &hydrate_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }

    sqlite3_bind_int(hydrate_statement, 1, primaryKey);

    int success = sqlite3_step(hydrate_statement);
    
	if (success == SQLITE_ROW) {
        self.lastUpdated = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(hydrate_statement, 0)];
    } else {
        self.lastUpdated = [NSDate date];
    }

    sqlite3_reset(hydrate_statement);

    hydrated = YES;
}


- (void)selectRelated {
	if (dataItems == nil) dataItems = [[NSMutableArray alloc] init];
	if (related) return;
	
	if (select_related_statement == nil) {
		const char *sql = "SELECT pk FROM data_items WHERE data_set=?";
		
		if (sqlite3_prepare_v2(database, sql, -1, &select_related_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
	}
	
	[dataItems removeAllObjects];
	
	sqlite3_bind_int(select_related_statement, 1, primaryKey);
	
	while (sqlite3_step(select_related_statement) == SQLITE_ROW) {
		int itemPrimaryKey = sqlite3_column_int(select_related_statement, 0);
		
		DataItem *dataItem = [[DataItem alloc] initWithPrimaryKey:itemPrimaryKey database:database];
		dataItem.dataSet = self;
		[dataItem selectRelated];
		[dataItems addObject:dataItem];
		[dataItem release];
	}
	
	sqlite3_reset(select_related_statement);
	
	related = YES;
}


- (void)save {
	if (dirty) {
        if (dehydrate_statement == nil) {
            const char *sql = "UPDATE data_sets SET name=?, last_updated=? WHERE pk=?";
			
            if (sqlite3_prepare_v2(database, sql, -1, &dehydrate_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
		
        sqlite3_bind_text(dehydrate_statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(dehydrate_statement, 2, [lastUpdated timeIntervalSince1970]);
        sqlite3_bind_int(dehydrate_statement, 3, primaryKey);
		
        int success = sqlite3_step(dehydrate_statement);
		
        sqlite3_reset(dehydrate_statement);
		
        if (success != SQLITE_DONE) {
            NSAssert1(0, @"Error: failed to dehydrate with message '%s'.", sqlite3_errmsg(database));
        }
		
        dirty = NO;
    }
}


- (void)dehydrate {
    [self save];

    [name release];
    name = nil;
	
    [lastUpdated release];
    lastUpdated = nil;

    hydrated = NO;
}


- (NSInteger)primaryKey {
    return primaryKey;
}

- (double)total {
	total = 0.0;
	
	for (DataItem *item in dataItems) {
		total += item.total;
	}
	
	return total;
}

- (NSString *)name {
    return name;
}

- (void)setName:(NSString *)aString {
    if ((!name && !aString) || (name && aString && [name isEqualToString:aString])) return;
    dirty = YES;
    [name release];
    name = [aString copy];
}

- (NSDate *)lastUpdated {
    return lastUpdated;
}

- (void)setLastUpdated:(NSDate *)aDate {
    if ((!lastUpdated && !aDate) || (lastUpdated && aDate && [lastUpdated isEqualToDate:aDate])) return;
    dirty = YES;
    [lastUpdated release];
    lastUpdated = [aDate copy];
}


- (void)removeDataItem:(DataItem *)dataItem {
    [dataItem deleteFromDatabase];
    [dataItems removeObject:dataItem];
}


- (void)addDataItem:(DataItem *)dataItem {
	dataItem.dataSet = self;
    [dataItem insertIntoDatabase:database];
    [dataItems addObject:dataItem];
}

@end
