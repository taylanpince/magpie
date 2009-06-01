//
//  DataSetViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SquirrelAppDelegate.h"
#import "DataSetViewController.h"
#import "EditableTableViewCell.h"
#import "DataSet.h"
#import "DataItem.h"


@implementation DataSetViewController

@synthesize dataSet, dataSetName, dataItems, activeTextField, deletedDataItems;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.editing = YES;
	self.tableView.allowsSelectionDuringEditing = YES;
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	if (dataSet.primaryKey) {
		self.title = dataSet.name;
	} else {
		self.title = @"New Data Set";
		saveButton.enabled = NO;
	}
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
	if (adding) {
		adding = NO;
		
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[dataItems count] inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (dataItems) [dataItems release];
	if (deletedDataItems) [deletedDataItems release];
	if (dataSetName) [dataSetName release];
	
	deletedDataItems = [[NSMutableArray alloc] init];
	
	if (dataSet.primaryKey) {
		[dataSet selectRelated];
		
		dataItems = [dataSet.dataItems mutableCopy];
		dataSetName = [dataSet.name mutableCopy];
		
		if (dataItems == nil) {
			dataItems = [[NSMutableArray alloc] init];
		}
	} else {
		dataItems = [[NSMutableArray alloc] init];
		dataSetName = [[NSMutableString alloc] init];
	}

}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!dataSet.primaryKey) {
		[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
	}
}


- (void)save:(id)sender {
	if (activeTextField) {
		[activeTextField resignFirstResponder];
	}
	
	dataSet.name = dataSetName;
	
	if (!dataSet.primaryKey) {
		[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] addDataSet:dataSet];
	}

	for (DataItem *dataItem in dataItems) {
		if (dataItem.name != nil & ![dataItem.name isEqualToString:@""]) {
			if ([dataSet.dataItems containsObject:dataItem]) {
				[dataItem dehydrate];
			} else {
				[dataSet addDataItem:dataItem];
			}
		}
	}
	
	for (DataItem *dataItem in deletedDataItems) {
		if ([dataSet.dataItems containsObject:dataItem]) {
			[dataSet removeDataItem:dataItem];
		}
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)cancel:(id)sender {
	dataItems = nil;
	dataSetName = nil;
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
	if (indexPath.section == 1 & indexPath.row == 0) {
		static NSString *CellIdentifier = @"AddCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.text = @"Add a new data item";
		
		return cell;
	} else {
		static NSString *CellIdentifier = @"NameCell";
		
		EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.delegate = self;
		cell.indexPath = indexPath;
		
		if (indexPath.section == 0) {
			cell.textField.text = dataSetName;
		} else {
			cell.textField.text = [[dataItems objectAtIndex:(indexPath.row - 1)] name];
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
	if (indexPath.section == 1 & indexPath.row == 0) {
		if (activeTextField) {
			[activeTextField resignFirstResponder];
		}

		[tableView deselectRowAtIndexPath:indexPath animated:YES];

		NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:1], nil];
		
		DataItem *dataItem = [[DataItem alloc] init];
		[dataItems insertObject:dataItem atIndex:0];
		[dataItem release];
		
		[tableView beginUpdates];
		[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
		[tableView endUpdates];
		
//		adding = YES;
//		EditableTableViewCell *cell = (EditableTableViewCell *)[tableView cellForRowAtIndexPath:[indexPaths objectAtIndex:0]];
//		[cell.textField becomeFirstResponder];
		[tableView selectRowAtIndexPath:[indexPaths objectAtIndex:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (activeTextField) {
			[activeTextField resignFirstResponder];
		}
		
		DataItem *dataItem = (DataItem *)[dataItems objectAtIndex:(indexPath.row - 1)];
		
		[deletedDataItems addObject:dataItem];
		[dataItems removeObject:dataItem];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


- (void)didBeginEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withTextField:(UITextField *)field {
	activeTextField = field;
}


- (void)didEndEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	if (indexPath.section == 0) {
		dataSetName = [newValue mutableCopy];
	} else {
		DataItem *dataItem = (DataItem *)[dataItems objectAtIndex:(indexPath.row - 1)];
		
		dataItem.name = newValue;
	}
}


- (void)didChangeEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	if (indexPath.section == 0) {
		UIBarButtonItem *saveButton = self.navigationItem.rightBarButtonItem;

		if ([newValue isEqualToString:@""]) {
			saveButton.enabled = NO;
		} else {
			saveButton.enabled = YES;
		}
	}
}


- (void)dealloc {
	[dataSet release];
	[dataItems release];
	[deletedDataItems release];
	[dataSetName release];
    [super dealloc];
}


@end

