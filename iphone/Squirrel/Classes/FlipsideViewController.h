//
//  FlipsideViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "AddSetViewController.h"

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddSetViewControllerDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	
	NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
	NSManagedObjectContext *addManagedObjectContext;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addManagedObjectContext;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
