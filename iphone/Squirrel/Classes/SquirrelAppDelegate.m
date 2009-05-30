//
//  SquirrelAppDelegate.m
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "SquirrelAppDelegate.h"
#import "MainViewController.h"
#import "DataSet.h"


@interface SquirrelAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end


@implementation SquirrelAppDelegate

@synthesize window, mainViewController, dataSets;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self createEditableCopyOfDatabaseIfNeeded];
	[self initializeDatabase];
	
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [self.applicationDocumentsDirectory stringByAppendingPathComponent:@"Squirrel.sql"];

    success = [fileManager fileExistsAtPath:writableDBPath];
    
	if (success) return;

    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Squirrel.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
	if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


- (void)initializeDatabase {
    NSMutableArray *dataSetsArray = [[NSMutableArray alloc] init];
    self.dataSets = dataSetsArray;
    [dataSetsArray release];

    NSString *path = [self.applicationDocumentsDirectory stringByAppendingPathComponent:@"Squirrel.sql"];

    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        const char *sql = "SELECT pk FROM data_sets";
        sqlite3_stmt *statement;

        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int primaryKey = sqlite3_column_int(statement, 0);

                DataSet *dataSet = [[DataSet alloc] initWithPrimaryKey:primaryKey database:database];
                [dataSets addObject:dataSet];
                [dataSet release];
            }
        }

        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [dataSets makeObjectsPerformSelector:@selector(dehydrate)];
    [DataSet finalizeStatements];

    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
}


- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;

    return basePath;
}


- (void)removeDataSet:(DataSet *)dataSet {
    [dataSet deleteFromDatabase];
    [dataSets removeObject:dataSet];
}


- (void)addDataSet:(DataSet *)dataSet {
    [dataSet insertIntoDatabase:database];
    [dataSets addObject:dataSet];
}


- (void)dealloc {
	[dataSets release];
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
