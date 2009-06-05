//
//  EditDataEntryViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EditDataEntryViewController.h"
#import "SelectableTableViewCell.h"
#import "KeyPadViewController.h"
#import "DataEntry.h"


@implementation EditDataEntryViewController

@synthesize dataEntry, formTableView, datePickerView, keyPad, dataEntryValue, dataEntryTimeStamp;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	if (dataEntryValue) [dataEntryValue release];
	if (dataEntryTimeStamp) [dataEntryTimeStamp release];
	
	if (dataEntry.primaryKey) {
		self.title = @"Edit Data Entry";
		
		dataEntryValue = [[dataEntry.value stringValue] mutableCopy];
		dataEntryTimeStamp = dataEntry.timeStamp;
	} else {
		self.title = @"Add Data Entry";
		saveButton.enabled = NO;
		
		dataEntryValue = [[NSMutableString alloc] initWithString:@"+ 0"];
		dataEntryTimeStamp = [[NSDate alloc] init];
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
		cell.dataLabel.text = dataEntryValue;
	} else {
		cell.titleLabel.text = @"Time Stamp";
		cell.dataLabel.text = [dataEntryTimeStamp description];
	}
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0 & !keyPad) {
		if (datePickerView) {
			[datePickerView removeFromSuperview];
			[datePickerView release];

			datePickerView = nil;
		}

		keyPad = [[KeyPadViewController alloc] initWithNibName:@"KeyPadView" bundle:nil];
		
		keyPad.delegate = self;
		keyPad.view.frame = CGRectMake(0.0, 200.0, self.view.frame.size.width, 216.0);
		
		[self.view addSubview:keyPad.view];
	} else if (!datePickerView) {
		if (keyPad) {
			[keyPad.view removeFromSuperview];
			[keyPad release];
			
			keyPad = nil;
		}

		datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200.0, self.view.frame.size.width, 216.0)];
		
		[self.view addSubview:datePickerView];
	}
}


- (void)didTapKeyPad:(KeyPadViewController *)keyPad onKey:(NSString *)key {
	if ([key isEqualToString:@"⌫"]) {
		if ([dataEntryValue length] > 3) {
			[dataEntryValue deleteCharactersInRange:NSMakeRange([dataEntryValue length] - 1, 1)];
		} else {
			[dataEntryValue release];
			dataEntryValue = [[NSMutableString alloc] initWithString:@"+ 0"];
		}
	} else if ([key isEqualToString:@"C"]) {
		[dataEntryValue release];
		dataEntryValue = [[NSMutableString alloc] initWithString:@"+ 0"];
	} else if ([key isEqualToString:@"±"]) {
		if ([dataEntryValue hasPrefix:@"+"]) {
			[dataEntryValue replaceCharactersInRange:NSMakeRange(0, 1) withString:@"-"];
		} else {
			[dataEntryValue replaceCharactersInRange:NSMakeRange(0, 1) withString:@"+"];
		}
	} else if ([key isEqualToString:@"."]) {
		NSRange range = [dataEntryValue rangeOfString:@"."];
		
		if (range.location == NSNotFound) {
			[dataEntryValue appendString:key];
		}
	} else {
		if ([[dataEntryValue substringFromIndex:2] isEqualToString:@"0"]) {
			[dataEntryValue replaceCharactersInRange:NSMakeRange(2, 1) withString:key];
		} else {
			[dataEntryValue appendString:key];
		}
	}

	[formTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[dataEntry release];
	[dataEntryValue release];
	[dataEntryTimeStamp release];
	[formTableView release];
	[datePickerView release];
	[keyPad release];
    [super dealloc];
}

@end
