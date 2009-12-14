//
//  DataEntryViewController.m
//  Magpie
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EntryViewController.h"
#import "QuickEntryViewController.h"
#import "InfoTableViewCell.h"
#import "Entry.h"
#import "Item.h"


@interface EntryViewController (PrivateMethods)
- (void)configureCell:(InfoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation EntryViewController

@synthesize item, dateFormatter, valueFormatter;
@synthesize fetchedResultsController, managedObjectContext;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setTitle:item.name];
	[self.navigationItem setLeftBarButtonItem:self.editButtonItem];
	
	if (dateFormatter) [dateFormatter release];
	if (valueFormatter) [valueFormatter release];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	valueFormatter = [[NSNumberFormatter alloc] init];
	
	[valueFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch:&error]) {
		// TODO: Handle the error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView reloadData];
}

- (void)save:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[fetchedResultsController fetchedObjects] count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Entries";
}

- (void)configureCell:(InfoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	[cell setIconType:@""];
	
	if (indexPath.row == 0) {
		[cell setMainLabel:@"Add new Entry"];
		[cell setSubLabel:@""];
	} else {
		Entry *entry = [[fetchedResultsController fetchedObjects] objectAtIndex:(indexPath.row - 1)];
		
		[cell setMainLabel:[valueFormatter stringFromNumber:entry.value]];
		[cell setSubLabel:[dateFormatter stringFromDate:entry.timeStamp]];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[InfoTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.row == 0) ? 42.0 : 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	QuickEntryViewController *controller = [[QuickEntryViewController alloc] initWithNibName:@"DataEntryView" bundle:nil];
	
	if (indexPath.row > 0) {
		[controller setEntry:[[fetchedResultsController fetchedObjects] objectAtIndex:(indexPath.row - 1)]];
	}
	
	[controller setItem:item];
	[controller setManagedObjectContext:managedObjectContext];
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		Entry *entry = [[fetchedResultsController fetchedObjects] objectAtIndex:(indexPath.row - 1)];
		
		[managedObjectContext deleteObject:entry];
		
		NSError *error;
		
		if (![managedObjectContext save:&error]) {
			// TODO: Handle the error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);
		}
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController != nil) {
		return fetchedResultsController;
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:managedObjectContext];
	
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"item == %@", item];
	
	[request setPredicate:predicate];
	
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
	NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
	
	[request setSortDescriptors:sorters];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	
	[controller setDelegate:self];
	
	self.fetchedResultsController = controller;
	
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
	NSIndexPath *newIndexPathWithOffset;
	NSIndexPath *indexPathWithOffset = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
	
	if (newIndexPath) {
		newIndexPathWithOffset = [NSIndexPath indexPathForRow:(newIndexPath.row + 1) inSection:newIndexPath.section];
	}
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPathWithOffset] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathWithOffset] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(InfoTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
		case NSFetchedResultsChangeMove:
			//[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			//[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)dealloc {
	[item release];
	[dateFormatter release];
	[valueFormatter release];
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}

@end