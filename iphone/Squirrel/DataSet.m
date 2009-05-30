// 
//  DataSet.m
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "DataSet.h"

static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *delete_statement = nil;
static sqlite3_stmt *hydrate_statement = nil;
static sqlite3_stmt *dehydrate_statement = nil;

@implementation DataSet 

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
            const char *sql = "SELECT name FROM data_sets WHERE pk=?";

            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }

        sqlite3_bind_int(init_statement, 1, primaryKey);
        
		if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
        } else {
            self.name = @"No name";
        }

        sqlite3_reset(init_statement);
        dirty = NO;
    }
    return self;
}


- (void)insertIntoDatabase:(sqlite3 *)db {
    database = db;

    if (insert_statement == nil) {
        static char *sql = "INSERT INTO data_sets (name) VALUES(?)";

        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }

    sqlite3_bind_text(insert_statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
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


- (void)dehydrate {
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

    [name release];
    name = nil;
    [lastUpdated release];
    lastUpdated = nil;

    hydrated = NO;
}


- (NSInteger)primaryKey {
    return primaryKey;
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

@end
