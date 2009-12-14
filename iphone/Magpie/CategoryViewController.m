//
//  CategoryViewController.m
//  Magpie
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "CategoryViewController.h"
#import "EditableTableViewCell.h"
#import "EntryViewController.h"
#import "Category.h"
#import "Item.h"


@implementation CategoryViewController

@synthesize category, managedObjectContext;
@synthesize activeTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setEditing:YES];
	[self.tableView setAllowsSelectionDuringEditing:YES];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	if (category != nil) {
		[self setTitle:category.name];
	} else {
		self.category = (Category *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectContext];
		
		[self setTitle:@"New Category"];
		[saveButton setEnabled:NO];
	}
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// TODO: Check to see if the object has been inserted or not
	/*if ([category ]) {
		[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
	}*/
}

- (void)save:(id)sender {
	if (activeTextField) {
		[activeTextField resignFirstResponder];
	}
	
	[category setLastUpdated:[NSDate date]];
	
	NSError *error;
	
	if (![managedObjectContext save:&error]) {
		// TODO: Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
	
	// TODO: Make delegate call so context can be merged
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender {
	// TODO: Make delegate call with no merging
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : [[category items] count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 0) ? nil : @"Items";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 & indexPath.row == 0) {
		static NSString *CellIdentifier = @"AddCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		[cell.textLabel setText:@"Add a new Item"];
		
		return cell;
	} else {
		static NSString *CellIdentifier = @"NameCell";
		
		EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		if (indexPath.row == 0) {
			[cell setEditingAccessoryType:UITableViewCellAccessoryNone];
		} else {
			[cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
		}
		
		[cell setDelegate:self];
		[cell setIndexPath:indexPath];
		
		if (indexPath.section == 0) {
			[cell.textField setText:category.name];
		} else {
			[cell.textField setText:[[[[category items] allObjects] objectAtIndex:(indexPath.row - 1)] name]];
		}
		
		return cell;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return UITableViewCellEditingStyleNone;
	} else {
		if (indexPath.row > 0) {
			return UITableViewCellEditingStyleDelete;
		} else {
			return UITableViewCellEditingStyleInsert;
		}
	}
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section > 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row == 0) {
		if (activeTextField) {
			[activeTextField resignFirstResponder];
		}

		[tableView deselectRowAtIndexPath:indexPath animated:YES];

		NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:1], nil];
		Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:managedObjectContext];
		
		[item setName:@""];
		[item setLastUpdated:[NSDate date]];
		[category addItemsObject:item];
		
		[tableView beginUpdates];
		[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
		[tableView endUpdates];
		
		[tableView selectRowAtIndexPath:[indexPaths objectAtIndex:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
		
		if (category.name != nil && ![category.name isEqualToString:@""]) {
			[self.navigationItem.rightBarButtonItem setEnabled:YES];
		}
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (activeTextField) {
		[activeTextField resignFirstResponder];
	}
	
	EntryViewController *controller = [[EntryViewController alloc] initWithStyle:UITableViewStyleGrouped];
	Item *item = [[[category items] allObjects] objectAtIndex:(indexPath.row - 1)];
	
	[controller setItem:item];
	[controller setManagedObjectContext:managedObjectContext];
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (activeTextField) {
			[activeTextField resignFirstResponder];
		}
		
		Item *item = [[[category items] allObjects] objectAtIndex:(indexPath.row - 1)];
		
		[category removeItemsObject:item];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		if ([[[category items] allObjects] count] == 0) {
			[self.navigationItem.rightBarButtonItem setEnabled:NO];
		}
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

- (void)didBeginEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withTextField:(UITextField *)field {
	activeTextField = field;
}

- (void)didEndEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	if (indexPath.section == 0) {
		[category setName:newValue];
	} else {
		Item *item = (Item *)[[[category items] allObjects] objectAtIndex:(indexPath.row - 1)];
		
		[item setName:newValue];
	}
}

- (void)didChangeEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	if (indexPath.section == 0) {
		if ([newValue isEqualToString:@""]) {
			[self.navigationItem.rightBarButtonItem setEnabled:NO];
		} else if ([[[category items] allObjects] count] > 0) {
			[self.navigationItem.rightBarButtonItem setEnabled:YES];
		}
	}
}

- (void)dealloc {
	[category release];
	[managedObjectContext release];
    [super dealloc];
}

@end