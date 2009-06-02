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

@synthesize dataEntry, formTableView, pickerView, datePickerView;

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


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	[formTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	[self tableView:formTableView didSelectRowAtIndexPath:indexPath];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 & !pickerView) {
		if (datePickerView) {
			[datePickerView removeFromSuperview];
			[datePickerView release];

			datePickerView = nil;
		}

		pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 200.0, self.view.frame.size.width, 216.0)];
		
		pickerView.delegate = self;
		pickerView.dataSource = self;
		
		[self.view addSubview:pickerView];
	} else if (!datePickerView) {
		if (pickerView) {
			[pickerView removeFromSuperview];
			[pickerView release];
			
			pickerView = nil;
		}

		datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200.0, self.view.frame.size.width, 216.0)];
		
		[self.view addSubview:datePickerView];
	}
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
	[formTableView release];
	[pickerView release];
	[datePickerView release];
    [super dealloc];
}

@end
