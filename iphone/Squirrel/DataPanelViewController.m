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
#import "DataSet.h"
#import "SelectDataSetViewController.h"


@implementation DataPanelViewController

@synthesize dataPanel, dataPanelName, dataPanelType, dataPanelSet, activeTextField;


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

	if (dataPanelName) [dataPanelName release];
	if (dataPanelType) [dataPanelType release];
	
	if (dataPanel.primaryKey) {
		[dataPanel hydrate];
		
		dataPanelName = [dataPanel.name mutableCopy];
		dataPanelType = [dataPanel.type mutableCopy];
		dataPanelSet = dataPanel.dataSet;
	} else {
		dataPanelName = [[NSMutableString alloc] init];
		dataPanelName = [[NSMutableString alloc] init];
		dataPanelSet = [[DataSet alloc] init];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSLog(@"Data Panel Set: %@", dataPanelSet.name);
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
	dataPanel.type = dataPanelType;
	dataPanel.dataSet = dataPanelSet;
	
	if (!dataPanel.primaryKey) {
		[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] addDataPanel:dataPanel];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)cancel:(id)sender {
	[dataPanelName release];
	dataPanelName = nil;
	
	[dataPanelType release];
	dataPanelType = nil;
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		static NSString *CellIdentifier = @"Cell";
		
		EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.delegate = self;
		cell.indexPath = indexPath;
		
		cell.textField.text = dataPanelName;
		
		return cell;
	} else {
		static NSString *CellIdentifier = @"SelectCell";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		if (indexPath.row == 1) {
			if (dataPanelSet.primaryKey) {
				cell.text = dataPanelSet.name;
			} else {
				cell.text = @"Select a Data Set";
			}
		} else if (indexPath.row == 2) {
			if (dataPanelType) {
				cell.text = dataPanelType;
			} else {
				cell.text = @"Select a Panel Type";
			}
		}

		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		SelectDataSetViewController *controller = [[SelectDataSetViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		controller.dataSet = dataPanelSet;
		controller.delegate = self;
		
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	} else if (indexPath.row == 2) {
		
	}
}


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


- (void)didUpdateDataSet:(DataSet *)newDataSet {
	if (![dataPanelSet isEqualTo:newDataSet]) {
		dataPanelSet = newDataSet;
		
		[self.tableView reloadData];
	}
}


- (void)dealloc {
	[dataPanel release];
	[dataPanelName release];
	[dataPanelType release];
    [super dealloc];
}


@end

