//
//  FlipsideViewController.m
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Hippo Foundry 2009. All rights reserved.
//

#import "FlipsideViewController.h"
#import "DataSetViewController.h"
#import "DataPanelViewController.h"
#import "InfoTableViewCell.h"
#import "HelpView.h"
#import "Category.h"
#import "Display.h"


@interface FlipsideViewController (PrivateMethods)
- (NSFetchedResultsController *)generateFetchedResultsControllerForModel:(NSString *)model withSortKey:(NSString *)sortKey;
@end


@implementation FlipsideViewController

@synthesize delegate, helpView;
@synthesize displaysFetchedResultsController, categoriesFetchedResultsController, managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Settings"];
	[self.navigationItem setLeftBarButtonItem:self.editButtonItem];

	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	helpView = nil;
	
	NSError *error;
	
	if (![[self displaysFetchedResultsController] performFetch:&error]) {
		// TODO: Handle the error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
	
	if (![[self categoriesFetchedResultsController] performFetch:&error]) {
		// TODO: Handle the error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (helpView != nil) {
		[helpView removeFromSuperview];
		[helpView release];
		
		helpView = nil;
	}
	
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([[categoriesFetchedResultsController fetchedObjects] count] == 0) {
		helpView = [[HelpView alloc] initWithFrame:CGRectMake(100.0, 120.0, 200.0, 170.0)];
		
		[helpView setAlpha:0.0];
		[helpView setHelpText:@"You should define a Category first. Categories are collections of Items, and each Item contains Entries. Tap on Add a new Category to continue."];
		[helpView setHelpBubbleCorner:2];
		
		[self.view addSubview:helpView];
		
		[UIView beginAnimations:@"fadeInHelp" context:NULL];
		[helpView setAlpha:1.0];
		[helpView setFrame:CGRectMake(100.0, 80.0, 200.0, 170.0)];
		[UIView commitAnimations];
	} else if ([[displaysFetchedResultsController fetchedObjects] count] == 0) {
		helpView = [[HelpView alloc] initWithFrame:CGRectMake(100.0, 250.0, 200.0, 135.0)];
		
		[helpView setAlpha:0.0];
		[helpView setHelpText:@"Add a Display to visualize the Category you created. Tap on Add a new Display to continue."];
		[helpView setHelpBubbleCorner:2];
		
		[self.view addSubview:helpView];
		
		[UIView beginAnimations:@"fadeInHelp" context:NULL];
		[helpView setAlpha:1.0];
		[helpView setFrame:CGRectMake(100.0, 210.0, 200.0, 135.0)];
		[UIView commitAnimations];
	}
}

- (void)save:(id)sender {
	[delegate flipsideViewControllerDidFinish:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [[categoriesFetchedResultsController fetchedObjects] count] + 1;
	} else {
		return [[displaysFetchedResultsController fetchedObjects] count] + 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[InfoTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	if (indexPath.section == 0) {
		if (indexPath.row == [[categoriesFetchedResultsController fetchedObjects] count]) {
			cell.mainLabel = @"Add a new Category";
			cell.subLabel = @"";
			cell.iconType = @"";
		} else {
			Category *category = [[categoriesFetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
			
			cell.mainLabel = category.name;
			cell.subLabel = @"";
			cell.iconType = @"";
		}
	} else {
		if (indexPath.row == [[displaysFetchedResultsController fetchedObjects] count]) {
			cell.mainLabel = @"Add a new Display";
			cell.subLabel = @"";
			cell.iconType = @"";
		} else {
			Display *display = [[displaysFetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
			
			cell.mainLabel = display.name;
			cell.subLabel = [NSString stringWithFormat:@"%@, %@", display.type, display.category.name];
			cell.iconType = display.type;
			cell.iconColor = display.color;
		}
	}

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row < [[displaysFetchedResultsController fetchedObjects] count]) {
		Display *display = [[displaysFetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
		
		UIFont *mainFont = [UIFont boldSystemFontOfSize:16];
		UIFont *subFont = [UIFont systemFontOfSize:12];

		CGSize mainLabelSize = [display.name sizeWithFont:mainFont constrainedToSize:CGSizeMake(221.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		CGSize subLabelSize = [[NSString stringWithFormat:@"%@, %@", display.type, display.category.name] sizeWithFont:subFont constrainedToSize:CGSizeMake(221.0, 20.0) lineBreakMode:UILineBreakModeTailTruncation];
		
		return mainLabelSize.height + subLabelSize.height + 25.0;
	} else if (indexPath.section == 0 && indexPath.row < [[categoriesFetchedResultsController fetchedObjects] count]) {
		Category *category = [[categoriesFetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
		
		UIFont *mainFont = [UIFont boldSystemFontOfSize:16];
		
		CGSize mainLabelSize = [category.name sizeWithFont:mainFont constrainedToSize:CGSizeMake(255.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		return mainLabelSize.height + 20.0;
	} else {
		return 42.0;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Categories" : @"Displays";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		// DEPRECATED
		/*DataSet *dataSet;
		
		if (indexPath.row == [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count]) {
			dataSet = [[[DataSet alloc] init] autorelease];
		} else {
			dataSet = [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:indexPath.row];
		}

		DataSetViewController *controller = [[DataSetViewController alloc] initWithStyle:UITableViewStyleGrouped];

		controller.dataSet = dataSet;
		
		[self.navigationController pushViewController:controller animated:YES];
		
		[controller release];*/
	} else {
		// DEPRECATED
		/*DataPanel *dataPanel;
		
		if (indexPath.row == [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]) {
			dataPanel = [[[DataPanel alloc] init] autorelease];
		} else {
			dataPanel = [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] objectAtIndex:indexPath.row];
		}
		
		DataPanelViewController *controller = [[DataPanelViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		controller.dataPanel = dataPanel;
		
		[self.navigationController pushViewController:controller animated:YES];
		
		[controller release];*/
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == [[categoriesFetchedResultsController fetchedObjects] count]) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
	} else {
		if (indexPath.row == [[displaysFetchedResultsController fetchedObjects] count]) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (indexPath.section == 0) {
			// DEPRECATED
			/*MagpieAppDelegate *appDelegate = (MagpieAppDelegate *)[[UIApplication sharedApplication] delegate];
			DataSet *dataSet = [[appDelegate dataSets] objectAtIndex:indexPath.row];
			
			NSMutableArray *deletedRows = [NSMutableArray arrayWithObject:indexPath];
			int rowNumber = 0;
			
			for (DataPanel *dataPanel in [appDelegate dataPanels]) {
				if (dataPanel.dataSet.primaryKey == dataSet.primaryKey) {
					[appDelegate removeDataPanel:dataPanel];
					[deletedRows addObject:[NSIndexPath indexPathForRow:rowNumber inSection:1]];
				}
				
				rowNumber++;
			}
			
			[appDelegate removeDataSet:dataSet];
			
			[tableView deleteRowsAtIndexPaths:deletedRows withRowAnimation:UITableViewRowAnimationFade];*/
		} else {
			// DEPRECATED
			/*MagpieAppDelegate *appDelegate = (MagpieAppDelegate *)[[UIApplication sharedApplication] delegate];
			DataPanel *dataPanel = [[appDelegate dataPanels] objectAtIndex:indexPath.row];
			
			[appDelegate removeDataPanel:dataPanel];
			
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];*/
		}
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// DEPRECATED
		//[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == 1 & indexPath.row < [[displaysFetchedResultsController fetchedObjects] count]);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	// DEPRECATED
	/*MagpieAppDelegate *appDelegate = (MagpieAppDelegate *)[[UIApplication sharedApplication] delegate];
	DataPanel *dataPanel = [[[appDelegate dataPanels] objectAtIndex:fromIndexPath.row] retain];
	
	[[appDelegate dataPanels] removeObjectAtIndex:fromIndexPath.row];
	[[appDelegate dataPanels] insertObject:dataPanel atIndex:toIndexPath.row];
	
	[appDelegate reorderDataPanels];*/
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	if (proposedDestinationIndexPath.section == 0) {
		return [NSIndexPath indexPathForRow:0 inSection:1];
	} else if (proposedDestinationIndexPath.row >= [[displaysFetchedResultsController fetchedObjects] count]) {
		return [NSIndexPath indexPathForRow:([[displaysFetchedResultsController fetchedObjects] count] - 1) inSection:1];
	} else {
		return proposedDestinationIndexPath;
	}
}

- (NSFetchedResultsController *)generateFetchedResultsControllerForModel:(NSString *)model withSortKey:(NSString *)sortKey {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:model inManagedObjectContext:managedObjectContext];
	
	[request setEntity:entity];
	
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:NO];
	NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
	
	[request setSortDescriptors:sorters];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
	
	[sorter release];
	[sorters release];
	[request release];
	
	return controller;
}

- (NSFetchedResultsController *)categoriesFetchedResultsController {
	if (self.categoriesFetchedResultsController != nil) {
		return categoriesFetchedResultsController;
	}
	
	NSFetchedResultsController *controller = [self generateFetchedResultsControllerForModel:@"Category" withSortKey:@"name"];
	
	self.categoriesFetchedResultsController = controller;
	
	[controller release];
	
	return categoriesFetchedResultsController;
}

- (NSFetchedResultsController *)displaysFetchedResultsController {
	if (self.displaysFetchedResultsController != nil) {
		return displaysFetchedResultsController;
	}
	
	NSFetchedResultsController *controller = [self generateFetchedResultsControllerForModel:@"Display" withSortKey:@"weight"];
	
	self.displaysFetchedResultsController = controller;
	
	[controller release];
	
	return displaysFetchedResultsController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	self.categoriesFetchedResultsController = nil;
	self.displaysFetchedResultsController = nil;
}

- (void)dealloc {
	[managedObjectContext release];
	[displaysFetchedResultsController release];
	[categoriesFetchedResultsController release];
	
	if (helpView != nil) {
		[helpView release];
	}

    [super dealloc];
}


@end
