//
//  FlipsideViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "DataSet.h"
#import "AddSetViewController.h"
#import "EditSetViewController.h"


@implementation FlipsideViewController

@synthesize delegate, managedObjectContext, addManagedObjectContext, fetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Settings";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	NSError *error;

	if (![[self fetchedResultsController] performFetch:&error]) {
		// Handle the error.
	}
}


- (void)viewWillAppear {
	[self.tableView reloadData];
}


- (void)save:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[fetchedResultsController fetchedObjects] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	if (indexPath.row == [[fetchedResultsController fetchedObjects] count]) {
		cell.textLabel.text = @"Add a new data set";
	} else {
		DataSet *dataSet = [fetchedResultsController objectAtIndexPath:indexPath];
		cell.textLabel.text = dataSet.name;
	}

    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Data Sets";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [[fetchedResultsController fetchedObjects] count]) {
		AddSetViewController *controller = [[AddSetViewController alloc] initWithStyle:UITableViewStyleGrouped];
		controller.delegate = self;
		
		NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
		self.addManagedObjectContext = addingContext;
		
		[addManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
		
		controller.dataSet = (DataSet *)[NSEntityDescription insertNewObjectForEntityForName:@"DataSet" inManagedObjectContext:addingContext];
		
		[self.navigationController pushViewController:controller animated:YES];

		[addingContext release];
		[controller release];
	} else {
		EditSetViewController *controller = [[EditSetViewController alloc] initWithStyle:UITableViewStyleGrouped];
		DataSet *dataSet = (DataSet *)[[self fetchedResultsController] objectAtIndexPath:indexPath];

		controller.dataSet = dataSet;
		
		[self.navigationController pushViewController:controller animated:YES];
		
		[controller release];
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [[fetchedResultsController fetchedObjects] count]) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;

		if (![context save:&error]) {
			// Handle the error.
		}
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


- (void)addSetViewController:(AddSetViewController *)controller didFinishWithSave:(BOOL)save {
	if (save) {
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addManagedObjectContext];
		
		NSError *error;
		
		if (![addManagedObjectContext save:&error]) {
			// Handle the error.
		}

		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addManagedObjectContext];
	}

	self.addManagedObjectContext = nil;
	
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
	[self.tableView reloadData];
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the DataSet entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DataSet" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	if (!self.editing) {
		[self.tableView reloadData];
	}
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	self.fetchedResultsController = nil;
}


- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[addManagedObjectContext release];
	
    [super dealloc];
}


@end
