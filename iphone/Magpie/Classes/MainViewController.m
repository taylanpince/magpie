//
//  MainViewController.m
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Hippo Foundry 2009. All rights reserved.
//

#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "QuickEntryViewController.h"
#import "IntroViewController.h"
#import "DisplayTableViewCell.h"
#import "StatOperation.h"
#import "HelpView.h"
#import "Display.h"
#import "Category.h"

#define displayCellID @"displayCell"


@interface MainViewController (PrivateMethods)
- (void)hideTutorial;
- (void)displayTutorial:(NSUInteger)step;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)statOperationComplete:(StatOperation *)operation;
- (void)reloadAllCells;
- (void)reloadVisibleCells;
@end


@implementation MainViewController

@synthesize tableView, quickEntryButton, helpView;
@synthesize managedObjectContext, fetchedResultsController;
@synthesize operationQueue;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tableView setAllowsSelection:NO];
	[tableView setDelegate:self];
	
	helpView = nil;
	operationQueue = [[NSOperationQueue alloc] init];
	
	[operationQueue setMaxConcurrentOperationCount:[[NSProcessInfo processInfo] activeProcessorCount] + 1];
	
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch:&error]) {
		// TODO: Handle the error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
	
	[self reloadAllCells];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[quickEntryButton setEnabled:([[fetchedResultsController fetchedObjects] count] > 0)];
	
	if (helpView != nil) {
		[helpView removeFromSuperview];
		[helpView release];
		
		helpView = nil;
	}
	
	[tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([[fetchedResultsController fetchedObjects] count] == 0) {
		[self displayTutorial:1];
	} else if ([[fetchedResultsController fetchedObjects] count] == 1 && [[[[fetchedResultsController fetchedObjects] objectAtIndex:0] category] total] == 0.0) {
		[self displayTutorial:2];
	} else if ([defaults boolForKey:@"tutorialCompleted"] == NO) {
		[defaults setBool:YES forKey:@"tutorialCompleted"];
		[self displayTutorial:3];
	}

	if ([defaults boolForKey:@"firstLaunch"] == NO) {
		[self showIntro];
	}
}

- (UIImage *)requestImageForDisplay:(Display *)display withIndex:(NSUInteger)cellIndex {
	if (display.hasImage == NO && display.hasQueuedOperation == NO) {
		StatOperation *operation = [[StatOperation alloc] initWithDisplay:display index:cellIndex];

		[operation setDelegate:self];
		[operationQueue addOperation:operation];
		[operation release];
		
		[display setHasQueuedOperation:YES];
	}
	
	return nil;
}

- (void)cancelOperationsForHiddenDisplays {
	for (StatOperation *operation in [operationQueue operations]) {
		if (!operation.isCancelled) {
			UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:operation.cellIndex inSection:0]];
			
			if (cell == nil) {
				operation.display.hasQueuedOperation = NO;
				
				[operation cancel];
			}
		}
	}
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self cancelOperationsForHiddenDisplays];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		[self cancelOperationsForHiddenDisplays];
	}
}

- (void)statOperationComplete:(StatOperation *)operation {
	if (operation.isCancelled) {
		return;
	}
	
	if ([NSThread isMainThread]) {
		DisplayTableViewCell *cell = (DisplayTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:operation.cellIndex inSection:0]];
		
		if (cell && operation.statImage) {
			[cell setStatImage:operation.statImage];
		}
		
		operation.display.hasQueuedOperation = NO;
		operation.display.hasImage = (operation.statImage != nil);
	} else {
		[self performSelectorOnMainThread:@selector(statOperationComplete:) withObject:operation waitUntilDone:NO];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DisplayTableViewCell *cell = (DisplayTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:displayCellID];
	
    if (cell == nil) {
        cell = [[[DisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:displayCellID] autorelease];
    }
    
	[self configureCell:cell atIndexPath:indexPath];
	
    return cell;
}

- (void)configureCell:(DisplayTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	Display *display = [fetchedResultsController objectAtIndexPath:indexPath];
	
	display.hasImage = NO;
	
	[cell setDisplay:display];
	[cell setStatImage:[self requestImageForDisplay:display withIndex:indexPath.row]];
}

- (void)reloadVisibleCells {
	int counter = 0;
	
	for (UITableViewCell *cell in [tableView visibleCells]) {
		[self configureCell:cell atIndexPath:[NSIndexPath indexPathForRow:counter inSection:0]];
		
		counter += 1;
	}
}

- (void)reloadAllCells {
	[operationQueue cancelAllOperations];
	
	for (Display *display in [fetchedResultsController fetchedObjects]) {
		display.hasImage = NO;
		display.hasQueuedOperation = NO;
	}
	
	[self reloadVisibleCells];
	[tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Display *display = [fetchedResultsController objectAtIndexPath:indexPath];
	
	if (display) {
		return [display heightForDisplay];
	} else {
		return 0.0;
	}

}

- (void)hideTutorial {
	[UIView beginAnimations:@"fadeOutHelp" context:NULL];
	[helpView setAlpha:0.0];
	[UIView commitAnimations];
}

- (void)displayTutorial:(NSUInteger)step {
	switch (step) {
		case 1:
			helpView = [[HelpView alloc] initWithFrame:CGRectMake(0.0, 355.0, 250.0, 100.0)];
			
			[helpView setAlpha:0.0];
			[helpView setHelpText:@"You don't seem to have any Displays setup yet. Tap on the gear icon below to start."];
			[helpView setHelpBubbleCorner:4];
			
			[self.view addSubview:helpView];
			
			[UIView beginAnimations:@"fadeInHelp" context:NULL];
			[helpView setAlpha:1.0];
			[helpView setFrame:CGRectMake(0.0, 325.0, 250.0, 100.0)];
			[UIView commitAnimations];
			break;
		case 2:
			helpView = [[HelpView alloc] initWithFrame:CGRectMake(112.0, 325.0, 220.0, 130.0)];
			
			[helpView setAlpha:0.0];
			[helpView setHelpText:@"Your Display is here, but there are no Entries yet.\nTap on the plus sign to launch the Quick Entry panel and add an Entry."];
			[helpView setHelpBubbleCorner:3];
			
			[self.view addSubview:helpView];
			
			[UIView beginAnimations:@"fadeInHelp" context:NULL];
			[helpView setAlpha:1.0];
			[helpView setFrame:CGRectMake(112.0, 285.0, 220.0, 130.0)];
			[UIView commitAnimations];
			break;
		case 3:
			helpView = [[HelpView alloc] initWithFrame:CGRectMake(0.0, 325.0, 250.0, 130.0)];
			
			[helpView setAlpha:0.0];
			[helpView setHelpText:@"Congratulations, you created your first Display and Entry!\nYou can also add, delete and modify Entries for an Item under its Category's settings panel."];
			[helpView setHelpBubbleCorner:4];
			
			[self.view addSubview:helpView];
			
			[UIView beginAnimations:@"fadeInHelp" context:NULL];
			[helpView setAlpha:1.0];
			[helpView setFrame:CGRectMake(0.0, 285.0, 250.0, 130.0)];
			[UIView commitAnimations];
			
			[NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(hideTutorial) userInfo:nil repeats:NO];
			break;
		default:
			break;
	}
}

- (void)didCloseQuickEntryView {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didCloseIntroView {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showSettings {
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	[controller setDelegate:self];
	[controller setManagedObjectContext:managedObjectContext];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:navController animated:YES];
	
	[controller release];
	[navController release];
}

- (IBAction)showQuickAdd {
	QuickEntryViewController *controller = [[QuickEntryViewController alloc] initWithNibName:@"DataEntryView" bundle:nil];
	
	[controller setDelegate:self];
	[controller setManagedObjectContext:managedObjectContext];
	
	Display *topDisplay = [(DisplayTableViewCell *)[[tableView visibleCells] objectAtIndex:0] display];
	
	[controller setItem:[[topDisplay.category.items allObjects] objectAtIndex:0]];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[self presentModalViewController:navController animated:YES];
	
	[controller release];
	[navController release];
}

- (IBAction)showIntro {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	IntroViewController *controller = [[IntroViewController alloc] initWithNibName:@"IntroView" bundle:nil];
	
	[controller setDelegate:self];

	if ([defaults boolForKey:@"firstLaunch"] == NO) {
		[defaults setBool:YES forKey:@"firstLaunch"];
		[controller setShowIntro:YES];
	}
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	
	[navController setNavigationBarHidden:YES];
	
	[self presentModalViewController:navController animated:YES];
	
	[controller release];
	[navController release];
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController != nil) {
		return fetchedResultsController;
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Display" inManagedObjectContext:managedObjectContext];
	
	[request setEntity:entity];
	
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"weight" ascending:YES];
	NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
	
	[request setSortDescriptors:sorters];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	
	self.fetchedResultsController = controller;
	self.fetchedResultsController.delegate = self;
	
	[sorter release];
	[sorters release];
	[request release];
	[controller release];
	
	return fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(DisplayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	self.fetchedResultsController = nil;
	self.operationQueue = nil;
}

- (void)dealloc {
	[managedObjectContext release];
	[fetchedResultsController release];
	
	if (helpView != nil) {
		[helpView release];
	}
	
	[tableView release];
	[quickEntryButton release];
	[operationQueue cancelAllOperations];
	[operationQueue release];
    [super dealloc];
}

@end