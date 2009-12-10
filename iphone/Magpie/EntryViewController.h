//
//  EntryViewController.h
//  Magpie
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@class Item;

@interface EntryViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	Item *item;
	
	NSDateFormatter *dateFormatter;
	NSNumberFormatter *valueFormatter;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) Item *item;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSNumberFormatter *valueFormatter;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end