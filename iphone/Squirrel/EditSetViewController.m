//
//  EditSetViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EditSetViewController.h"
#import "EditableTableViewCell.h"
#import "DataSet.h"
#import "DataItem.h"


@implementation EditSetViewController

@synthesize dataSet, dataItems, activeTextField;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = dataSet.name;
	self.editing = YES;
	self.tableView.allowsSelectionDuringEditing = YES;
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[dataSet hydrate];
	
	dataItems = [dataSet.dataItems mutableCopy];
	
	if (dataItems == nil) {
		dataItems = [[NSMutableArray alloc] init];
	}
}


- (void)save:(id)sender {
	if (activeTextField) {
		[activeTextField resignFirstResponder];
	}
	NSLog(@"Data Set Data Items: %@", dataSet.dataItems);
	for (DataItem *dataItem in dataItems) {
		if (dataItem.name != nil & ![dataItem.name isEqualToString:@""]) {
			if ([dataSet.dataItems containsObject:dataItem]) {
				NSLog(@"Update %@", dataItem.name);
				[dataItem dehydrate];
			} else {
				NSLog(@"Insert %@", dataItem.name);
				[dataSet addDataItem:dataItem];
			}
		}
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
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
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : [dataItems count] + 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 0) ? nil : @"Data Items";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 | indexPath.row < [dataItems count]) {
		static NSString *CellIdentifier = @"NameCell";
		
		EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.delegate = self;
		cell.indexPath = indexPath;
		
		if (indexPath.section == 0) {
			cell.textField.text = dataSet.name;
		} else {
			cell.textField.text = [[dataItems objectAtIndex:indexPath.row] name];
		}
		
		return cell;
	} else {
		static NSString *CellIdentifier = @"AddCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.text = @"Add a new data item";
		
		return cell;
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return UITableViewCellEditingStyleNone;
	} else {
		if (indexPath.row < [dataItems count]) {
			return UITableViewCellEditingStyleDelete;
		} else {
			return UITableViewCellEditingStyleInsert;
		}
	}
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section > 0);
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 & indexPath.row == [dataItems count]) {
		return indexPath;
	} else {
		return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (activeTextField) {
		[activeTextField resignFirstResponder];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[dataItems count] inSection:1], nil];
	
	DataItem *dataItem = [[DataItem alloc] init];
	[dataItems addObject:dataItem];
	[dataItem release];
	
    [tableView beginUpdates];
	[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		DataItem *dataItem = (DataItem *)[dataItems objectAtIndex:indexPath.row];
		
		if ([dataSet.dataItems containsObject:dataItem]) {
			[dataSet removeDataItem:dataItem];
		}
		
		[dataItems removeObject:dataItem];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


- (void)didBeginEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withTextField:(UITextField *)field {
	self.activeTextField = field;
}


- (void)didEndEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	if (indexPath.section == 0) {
		dataSet.name = newValue;
	} else {
		DataItem *dataItem = (DataItem *)[dataItems objectAtIndex:indexPath.row];
		
		dataItem.name = newValue;
	}
}


- (void)dealloc {
	[dataItems release];
    [super dealloc];
}


@end

