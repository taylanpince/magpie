//
//  EditDataEntryViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EditDataEntryViewController.h"
#import "SelectableTableViewCell.h"
#import "DataEntry.h"


@implementation EditDataEntryViewController

@synthesize dataEntry;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	if (dataEntry.primaryKey) {
		self.title = @"Edit Data Entry";
	} else {
		self.title = @"Add Data Entry";
		saveButton.enabled = NO;
	}
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
}


- (void)save:(id)sender {
	
}


- (void)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	SelectableTableViewCell *cell = (SelectableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[SelectableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	if (indexPath.row == 0) {
		cell.titleLabel.text = @"Value";
	} else {
		cell.titleLabel.text = @"Time Stamp";
	}
	
	return cell;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 7;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (component == 0) {
		return 2;
	} else if (component == 4) {
		return 1;
	} else {
		return 10;
	}
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (component == 0) {
		return (row == 0) ? @"+" : @"-";
	} else if (component == 4) {
		return @".";
	} else {
		return [NSString stringWithFormat:@"%d", row];
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}

@end
