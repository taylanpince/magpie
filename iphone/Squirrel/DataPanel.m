//
//  DataPanel.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "DataPanel.h"
#import "DataSet.h"

static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *delete_statement = nil;
static sqlite3_stmt *hydrate_statement = nil;
static sqlite3_stmt *dehydrate_statement = nil;

@implementation DataPanel

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
            const char *sql = "SELECT name, type, weight FROM data_panels WHERE pk=?";
			
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
		
        sqlite3_bind_int(init_statement, 1, primaryKey);
        
		if (sqlite3_step(init_statement) == SQLITE_ROW) {
			char *nameStr = (char *)sqlite3_column_text(init_statement, 0);
            self.name = (nameStr) ? [NSString stringWithUTF8String:nameStr] : @"";

			char *typeStr = (char *)sqlite3_column_text(init_statement, 1);
			self.type = (typeStr) ? [NSString stringWithUTF8String:typeStr] : @"";
			
			self.weight = [NSNumber numberWithInt:sqlite3_column_int(init_statement, 2)];
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
        static char *sql = "INSERT INTO data_panels (name,data_set,type,weight,color) VALUES(?,?,?,?,?)";
		
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
    sqlite3_bind_text(insert_statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_statement, 2, [dataSet primaryKey]);
    sqlite3_bind_text(insert_statement, 3, [type UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insert_statement, 4, [weight intValue]);
    sqlite3_bind_text(insert_statement, 5, [color UTF8String], -1, SQLITE_TRANSIENT);
	
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
	[type release];
	[weight release];
	[dataSet release];
	[color release];
    [super dealloc];
}

- (void)deleteFromDatabase {
    if (delete_statement == nil) {
        const char *sql = "DELETE FROM data_panels WHERE pk=?";
		
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
        const char *sql = "SELECT type, weight, data_set, color FROM data_panels WHERE pk=?";
		
        if (sqlite3_prepare_v2(database, sql, -1, &hydrate_statement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
	
    sqlite3_bind_int(hydrate_statement, 1, primaryKey);
	
    int success = sqlite3_step(hydrate_statement);
    
	if (success == SQLITE_ROW) {
        char *typeCopy = (char *)sqlite3_column_text(hydrate_statement, 0);
        char *colorCopy = (char *)sqlite3_column_text(hydrate_statement, 3);
		
		self.type = (typeCopy) ? [NSString stringWithUTF8String:typeCopy] : @"";
		self.weight = [NSNumber numberWithInt:sqlite3_column_int(hydrate_statement, 1)];
		self.dataSet = [[DataSet alloc] initWithPrimaryKey:sqlite3_column_int(hydrate_statement, 2) database:database];
		self.color = (colorCopy) ? [NSString stringWithUTF8String:colorCopy] : @"";
    }
	
    sqlite3_reset(hydrate_statement);
	
    hydrated = YES;
}


- (void)forceHydrate {
	hydrated = NO;
	
	[self hydrate];
}


- (void)dehydrate {
    if (dirty) {
        if (dehydrate_statement == nil) {
            const char *sql = "UPDATE data_panels SET name=?, type=?, weight=?, data_set=?, color=? WHERE pk=?";
			
            if (sqlite3_prepare_v2(database, sql, -1, &dehydrate_statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
		
        sqlite3_bind_text(dehydrate_statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(dehydrate_statement, 2, [type UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(dehydrate_statement, 3, [weight intValue]);
        sqlite3_bind_int(dehydrate_statement, 4, [dataSet primaryKey]);
        sqlite3_bind_text(dehydrate_statement, 5, [color UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(dehydrate_statement, 6, primaryKey);
		
        int success = sqlite3_step(dehydrate_statement);
		
        sqlite3_reset(dehydrate_statement);
		
        if (success != SQLITE_DONE) {
            NSAssert1(0, @"Error: failed to dehydrate with message '%s'.", sqlite3_errmsg(database));
        }
		
        dirty = NO;
    }
	
    [name release];
    name = nil;
	
    [type release];
    type = nil;
	
    [weight release];
    weight = nil;
	
    [dataSet release];
    dataSet = nil;
	
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

- (NSString *)color {
    return color;
}

- (void)setColor:(NSString *)aColor {
    if ((!color && !aColor) || (color && aColor && [color isEqualToString:aColor])) return;
    dirty = YES;
    [color release];
    color = [aColor copy];
}

- (NSString *)type {
    return type;
}

- (void)setType:(NSString *)aType {
    if ((!type && !aType) || (type && aType && [type isEqualToString:aType])) return;
    dirty = YES;
    [type release];
    type = [aType copy];
}

- (NSNumber *)weight {
    return weight;
}

- (void)setWeight:(NSNumber *)aWeight {
    if ((!weight && !aWeight) || (weight && aWeight && weight == aWeight)) return;
    dirty = YES;
    [weight release];
    weight = [aWeight copy];
}

- (DataSet *)dataSet {
    return dataSet;
}

- (void)setDataSet:(DataSet *)aDataSet {
    if ((!dataSet && !aDataSet) || (dataSet && aDataSet && [dataSet isEqual:aDataSet])) return;
    dirty = YES;
    [dataSet release];
    dataSet = [aDataSet retain];
}

@end
