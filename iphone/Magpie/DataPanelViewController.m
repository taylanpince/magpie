//
//  DataPanelViewController.m
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "MagpieAppDelegate.h"
#import "DataPanelViewController.h"
#import "EditableTableViewCell.h"
#import	"SelectableTableViewCell.h"
#import "DataPanel.h"
#import "DataSet.h"
#import "SelectDataSetViewController.h"
#import "SelectPanelTypeViewController.h"
#import "SelectPanelColorViewController.h"


@implementation DataPanelViewController

@synthesize dataPanel, dataPanelName, dataPanelType, dataPanelSet, dataPanelColor, activeTextField;


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
	if (dataPanelColor) [dataPanelColor release];
	
	if (dataPanel.primaryKey) {
		[dataPanel hydrate];
		
		dataPanelName = [dataPanel.name mutableCopy];
		dataPanelType = [dataPanel.type mutableCopy];
		dataPanelColor = [dataPanel.color mutableCopy];
		dataPanelSet = dataPanel.dataSet;
	} else {
		dataPanelName = [[NSMutableString alloc] init];
		dataPanelType = [[NSMutableString alloc] init];
		dataPanelColor = [[NSMutableString alloc] initWithString:@"Blue"];
	}
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
	dataPanel.color = dataPanelColor;
	dataPanel.dataSet = dataPanelSet;
	
	if (!dataPanel.primaryKey) {
		[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] addDataPanel:dataPanel];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)cancel:(id)sender {
	[dataPanelName release];
	dataPanelName = nil;
	
	[dataPanelType release];
	dataPanelType = nil;
	
	[dataPanelColor release];
	dataPanelColor = nil;
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
		
		SelectableTableViewCell *cell = (SelectableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[SelectableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		if (indexPath.row == 1) {
			cell.titleLabel.text = @"Data Set";
			
			if (dataPanelSet.primaryKey) {
				cell.dataLabel.text = dataPanelSet.name;
				cell.blank = NO;
			} else {
				cell.dataLabel.text = @"Select a Data Set";
				cell.blank = YES;
			}
		} else if (indexPath.row == 2) {
			cell.titleLabel.text = @"Panel Type";
			
			if (![dataPanelType isEqualToString:@""]) {
				cell.dataLabel.text = dataPanelType;
				cell.blank = NO;
			} else {
				cell.dataLabel.text = @"Select a Panel Type";
				cell.blank = YES;
			}
		} else if (indexPath.row == 3) {
			cell.titleLabel.text = @"Panel Color";
			cell.dataLabel.text = dataPanelColor;
			cell.blank = NO;
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
		SelectPanelTypeViewController *controller = [[SelectPanelTypeViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		controller.panelType = dataPanelType;
		controller.delegate = self;
		
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	} else if (indexPath.row == 3) {
		SelectPanelColorViewController *controller = [[SelectPanelColorViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		controller.panelColor = dataPanelColor;
		controller.delegate = self;
		
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
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
	} else if (![dataPanelType isEqualToString:@""] & dataPanelSet != nil) {
		saveButton.enabled = YES;
	}
}


- (void)didUpdateDataSet:(DataSet *)newDataSet {
	dataPanelSet = newDataSet;
	
	[self.tableView reloadData];
	
	if (![dataPanelName isEqualToString:@""] && ![dataPanelType isEqualToString:@""]) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
}


- (void)didUpdatePanelType:(NSMutableString *)newPanelType {
	if (![dataPanelType isEqualToString:newPanelType]) {
		[dataPanelType release];
		
		dataPanelType = newPanelType;
		
		[self.tableView reloadData];
		
		if (![dataPanelName isEqualToString:@""] && dataPanelSet != nil) {
			self.navigationItem.rightBarButtonItem.enabled = YES;
		}
	}
}


- (void)didUpdatePanelColor:(NSMutableString *)newPanelColor {
	if (![dataPanelColor isEqualToString:newPanelColor]) {
		[dataPanelColor release];
		
		dataPanelColor = newPanelColor;
		
		[self.tableView reloadData];
		
		if (![dataPanelName isEqualToString:@""] && dataPanelType != nil && dataPanelSet != nil) {
			self.navigationItem.rightBarButtonItem.enabled = YES;
		}
	}
}


- (void)dealloc {
	[dataPanel release];
	[dataPanelName release];
	[dataPanelType release];
	[dataPanelColor release];
    [super dealloc];
}


@end

