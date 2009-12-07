//
//  SelectCategoryViewController.m
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "Category.h"


@implementation SelectCategoryViewController

@synthesize category, delegate, fetchedResultsController, managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch:&error]) {
		// TODO: Handle the error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	self.fetchedResultsController = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Category *cellCategory = [fetchedResultsController objectAtIndexPath:indexPath];
	
	if (cellCategory == category) {
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	
	[cell.textLabel setText:cellCategory.name];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[delegate didUpdateCategory:[fetchedResultsController objectAtIndexPath:indexPath]];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController != nil) {
		return fetchedResultsController;
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
	
	[request setEntity:entity];
	
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
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

- (void)dealloc {
	[category release];
	[fetchedResultsController release];
	[managedObjectContext release];
    [super dealloc];
}

@end