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
@end


@implementation MainViewController

@synthesize tableView, quickEntryButton, helpView;
@synthesize managedObjectContext, fetchedResultsController;
@synthesize operationQueue, placeHolderImage;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[tableView setAllowsSelection:NO];
	
	helpView = nil;
	placeHolderImage = [[UIImage imageNamed:@"placeholder.png"] retain];
	
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch:&error]) {
		// TODO: Handle the error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
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
	
	return placeHolderImage;
}

- (void)statOperationComplete:(StatOperation *)operation {
	
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
	
	[cell setDisplay:display];
	[cell setStatImage:[self requestImageForDisplay:display withIndex:indexPath.row]];
	/*[cell.textLabel setText:display.name];
	[cell.detailTextLabel setText:[NSString stringWithFormat:@"%1.2f", display.category.total]];*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	Display *display = [fetchedResultsController objectAtIndexPath:indexPath];
	
	return [display heightForDisplay];
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
	[tableView reloadData];
}

- (void)didCloseIntroView {
	[self dismissModalViewControllerAnimated:YES];
	[tableView reloadData];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
	[tableView reloadData];
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
	[controller setItem:[[[(Category *)[[[fetchedResultsController fetchedObjects] objectAtIndex:0] category] items] allObjects] objectAtIndex:0]];
	// TODO: Use [tableView visibleCells] to figure out which display to use for the entry panel
	
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
	
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"weight" ascending:NO];
	NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
	
	[request setSortDescriptors:sorters];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	
	self.fetchedResultsController = controller;
	
	[sorter release];
	[sorters release];
	[request release];
	[controller release];
	
	return fetchedResultsController;
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
	[placeHolderImage release];
    [super dealloc];
}

@end