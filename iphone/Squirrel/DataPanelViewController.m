//
//  DataPanelViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SquirrelAppDelegate.h"
#import "DataPanelViewController.h"
#import "EditableTableViewCell.h"
#import "DataPanel.h"


@implementation DataPanelViewController

@synthesize dataPanel, dataPanelName, activeTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	if (dataPanel.primaryKey) {
		self.title = dataPanel.name;
	} else {
		self.title = @"New Data Panel";
		saveButton.enabled = NO;
	}
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (dataPanelName) [dataPanelName release];
	
	if (dataPanel.primaryKey) {
		dataPanelName = [dataPanel.name mutableCopy];
	} else {
		dataPanelName = [[NSMutableString alloc] init];
	}
	
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!dataPanel.primaryKey) {
		[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
	}
}


- (void)save:(id)sender {
	if (activeTextField) {
		[activeTextField resignFirstResponder];
	}
	
	dataPanel.name = dataPanelName;
	
	if (!dataPanel.primaryKey) {
		[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] addDataPanel:dataPanel];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)cancel:(id)sender {
	dataPanelName = nil;
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.delegate = self;
	cell.indexPath = indexPath;
	
	cell.textField.text = dataPanelName;
	
	return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (indexPath.section == 1 & indexPath.row == 0) {
//		if (activeTextField) {
//			[activeTextField resignFirstResponder];
//		}
//		
//		[tableView deselectRowAtIndexPath:indexPath animated:YES];
//		
//		NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:1], nil];
//		
//		DataItem *dataItem = [[DataItem alloc] init];
//		[dataItems insertObject:dataItem atIndex:0];
//		[dataItem release];
//		
//		[tableView beginUpdates];
//		[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
//		[tableView endUpdates];
//		
//		[tableView selectRowAtIndexPath:[indexPaths objectAtIndex:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
//	}
//}


- (void)didBeginEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withTextField:(UITextField *)field {
	activeTextField = field;
}


- (void)didEndEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	dataPanelName = [newValue mutableCopy];
}


- (void)didChangeEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	UIBarButtonItem *saveButton = self.navigationItem.rightBarButtonItem;
	
	if ([newValue isEqualToString:@""]) {
		saveButton.enabled = NO;
	} else {
		saveButton.enabled = YES;
	}
}


- (void)dealloc {
	[dataPanel release];
	[dataPanelName release];
    [super dealloc];
}


@end

