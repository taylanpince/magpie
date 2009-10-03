//
//  MagpieAppDelegate.m
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "MagpieAppDelegate.h"
#import "MainViewController.h"
#import "DataSet.h"
#import "DataItem.h"
#import "DataPanel.h"
#import "DataEntry.h"


@implementation MagpieAppDelegate

@synthesize window, mainViewController, dataSets, dataPanels;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSManagedObjectContext *context = [self managedObjectContext];
	
	if (!context) {
		// Handle errors here
	}
	
	MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];

	[self setMainViewController:controller];

	[mainViewController setContext:context];
	[[[mainViewController view] setFrame:[[UIScreen mainScreen] applicationFrame]]];
	
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
	
	[controller release];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSError *error = nil;
	
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle errors here
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
	return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	
    return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Magpie.sqlite"]];
	NSError *error = nil;
	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		// Handle errors here
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (void)removeDataSet:(DataSet *)dataSet {
    [dataSet deleteFromDatabase];
    [dataSets removeObject:dataSet];
}


- (void)addDataSet:(DataSet *)dataSet {
    [dataSet insertIntoDatabase:database];
    [dataSets addObject:dataSet];
}


- (void)removeDataPanel:(DataPanel *)dataPanel {
    [dataPanel deleteFromDatabase];
    [dataPanels removeObject:dataPanel];
}


- (void)addDataPanel:(DataPanel *)dataPanel {
	dataPanel.weight = [NSNumber numberWithInt:[dataPanels count]];
	
    [dataPanel insertIntoDatabase:database];
    [dataPanels addObject:dataPanel];
}


- (void)reorderDataPanels {
	int order = 0;
	
	for (DataPanel *dataPanel in dataPanels) {
		dataPanel.weight = [NSNumber numberWithInt:order];
		order++;
	}
}


- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];

	[dataSets release];
	[dataPanels release];
    
	[mainViewController release];
    [window release];
	
	[super dealloc];
}

@end
