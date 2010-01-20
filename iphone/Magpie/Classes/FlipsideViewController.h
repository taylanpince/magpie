//
//  FlipsideViewController.h
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Hippo Foundry 2009. All rights reserved.
//

@class HelpView;

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *displaysFetchedResultsController;
	NSFetchedResultsController *categoriesFetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	id <FlipsideViewControllerDelegate> delegate;
	
	HelpView *helpView;
	
	BOOL changeIsUserDriven;
}

@property (nonatomic, retain) NSFetchedResultsController *displaysFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *categoriesFetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) HelpView *helpView;

@property (nonatomic, assign) BOOL changeIsUserDriven;

@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
