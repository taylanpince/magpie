//
//  FlipsideViewController.h
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Hippo Foundry 2009. All rights reserved.
//

#import "DisplayViewController.h"

@class HelpView;

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UITableViewController <NSFetchedResultsControllerDelegate, DisplayViewControllerDelegate> {
	NSFetchedResultsController *displaysFetchedResultsController;
	NSFetchedResultsController *categoriesFetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectContext *scratchObjectContext;
	
	HelpView *helpView;
	BOOL changeIsUserDriven;
	
	id <FlipsideViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSFetchedResultsController *displaysFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *categoriesFetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *scratchObjectContext;

@property (nonatomic, retain) HelpView *helpView;
@property (nonatomic, assign) BOOL changeIsUserDriven;

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
