//
//  DataEntry.m
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "DataEntry.h"
#import "DataItem.h"


static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *delete_statement = nil;
static sqlite3_stmt *hydrate_statement = nil;
static sqlite3_stmt *dehydrate_statement = nil;

@implementation DataEntry

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
}


- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
    if (self = [super init]) {
        primaryKey = pk;
        database = db;
		
        if (init_statement == nil) {
            const char *sql = "SELECT value,timestamp FROM data_entries WHERE pk=?";
			
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
		
        sqlite3_bind_int(init_statement, 1, primaryKey);
        
		if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.value = [NSNumber numberWithFloat:sqlite3_column_double(init_statement, 0)];
			self.timeStamp = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(init_statement, 1)];
        }
		
        sqlite3_reset(init_statement);
        dirty = NO;
    }
    return self;
}


- (void)insertIntoDatabase:(sqlite3 *)db {
    database = db;
	
    if (insert_statement == nil) {
        static char *sql = "INSERT INTO data_entries (value,timestamp,data_item) VALUES(?,?,?)";
		
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
    sqlite3_bind_double(insert_statement, 1, [value floatValue]);
	sqlite3_bind_int(insert_statement, 2, [timeStamp timeIntervalSince1970]);
	sqlite3_bind_int(insert_statement, 3, [dataItem primaryKey]);
	
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
    [value release];
	[timeStamp release];
	[dataItem release];
    [super dealloc];
}

- (void)deleteFromDatabase {
    if (delete_statement == nil) {
        const char *sql = "DELETE FROM data_entries WHERE pk=?";
		
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
}


- (void)hydrate {
    if (hydrated) return;
	
    if (hydrate_statement == nil) {
        const char *sql = "SELECT data_item FROM data_entries WHERE pk=?";
		
        if (sqlite3_prepare_v2(database, sql, -1, &hydrate_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
    sqlite3_bind_int(hydrate_statement, 1, primaryKey);
	
    int success = sqlite3_step(hydrate_statement);
    
	if (success == SQLITE_ROW) {
		self.dataItem = [[DataItem alloc] initWithPrimaryKey:sqlite3_column_int(hydrate_statement, 0) database:database];
    }
	
    sqlite3_reset(hydrate_statement);
	
    hydrated = YES;
}


- (void)dehydrate {
    if (dirty) {
        if (dehydrate_statement == nil) {
            const char *sql = "UPDATE data_entries SET value=?, timestamp=?, data_set=? WHERE pk=?";
			
            if (sqlite3_prepare_v2(database, sql, -1, &dehydrate_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
		
		sqlite3_bind_double(dehydrate_statement, 1, [value floatValue]);
		sqlite3_bind_int(dehydrate_statement, 2, [timeStamp timeIntervalSince1970]);
		sqlite3_bind_int(dehydrate_statement, 3, [dataItem primaryKey]);
        sqlite3_bind_int(dehydrate_statement, 4, primaryKey);
		
        int success = sqlite3_step(dehydrate_statement);
		
        sqlite3_reset(dehydrate_statement);
		
        if (success != SQLITE_DONE) {
            NSAssert1(0, @"Error: failed to dehydrate with message '%s'.", sqlite3_errmsg(database));
        }
		
        dirty = NO;
    }
	
	//    [name release];
	//    name = nil;
	//	
	//    [dataSet release];
	//    dataSet = nil;
	
    hydrated = NO;
}


- (NSInteger)primaryKey {
    return primaryKey;
}

- (NSNumber *)value {
    return value;
}

- (void)setValue:(NSNumber *)aValue {
    if ((!value && !aValue) || (value && aValue && value == aValue)) return;
    dirty = YES;
    [value release];
    value = [aValue copy];
}

- (NSDate *)timeStamp {
	return timeStamp;
}

- (void)setTimeStamp:(NSDate *)aTimeStamp {
    if ((!timeStamp && !aTimeStamp) || (timeStamp && aTimeStamp && [timeStamp isEqualToDate:aTimeStamp])) return;
	dirty = YES;
	[timeStamp release];
	timeStamp = [aTimeStamp copy];
}

- (DataItem *)dataItem {
    return dataItem;
}

- (void)setDataItem:(DataItem *)aDataItem {
    if ((!dataItem && !aDataItem) || (dataItem && aDataItem && [dataItem isEqual:aDataItem])) return;
    dirty = YES;
    [dataItem release];
    dataItem = [aDataItem retain];
}

@end
