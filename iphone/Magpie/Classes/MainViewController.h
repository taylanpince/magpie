//
//  MainViewController.h
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Hippo Foundry 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "QuickEntryViewController.h"
#import "IntroViewController.h"

@class HelpView;

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FlipsideViewControllerDelegate, QuickEntryViewControllerDelegate, IntroViewControllerDelegate> {
	IBOutlet UITableView *tableView;
	IBOutlet UIBarButtonItem *quickEntryButton;
	
	HelpView *helpView;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *quickEntryButton;

@property (nonatomic, retain) HelpView *helpView;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction)showSettings;
- (IBAction)showQuickAdd;
- (IBAction)showIntro;

@end