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
#import "DataItem.h"


@implementation EditDataEntryViewController

@synthesize dataEntry, dataItem, formTableView, datePickerView, keyPad, dataEntryValue, dataEntryTimeStamp, dateFormatter, valueFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	if (dataEntryValue) [dataEntryValue release];
	if (dataEntryTimeStamp) [dataEntryTimeStamp release];
	if (dateFormatter) [dateFormatter release];
	if (valueFormatter) [valueFormatter release];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	valueFormatter = [[NSNumberFormatter alloc] init];
	[valueFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[valueFormatter setHasThousandSeparators:YES];
	
	if (dataEntry.primaryKey) {
		self.title = @"Edit Data Entry";
		
		dataEntryValue = [dataEntry.value copy];
		dataEntryTimeStamp = [dataEntry.timeStamp copy];
	} else {
		self.title = @"Add Data Entry";
		
		dataEntryValue = [[NSNumber alloc] initWithFloat:0.0];
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
	dataEntry.value = dataEntryValue;
	dataEntry.timeStamp = dataEntryTimeStamp;
	
	if (!dataEntry.primaryKey) {
		[dataItem addDataEntry:dataEntry];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
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
		cell.dataLabel.text = [valueFormatter stringFromNumber:dataEntryValue];
	} else {
		cell.titleLabel.text = @"Time Stamp";
		cell.dataLabel.text = [dateFormatter stringFromDate:dataEntryTimeStamp];
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
	} else if (indexPath.row == 1 & !datePickerView) {
		if (keyPad) {
			[keyPad.view removeFromSuperview];
			[keyPad release];
			
			keyPad = nil;
		}

		datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200.0, self.view.frame.size.width, 216.0)];
		
		[datePickerView addTarget:self action:@selector(didSelectDate:) forControlEvents:UIControlEventValueChanged];
		[datePickerView setDate:dataEntryTimeStamp];
		[self.view addSubview:datePickerView];
	}
}


- (void)didSelectDate:(id)sender {
	[dataEntryTimeStamp release];
	
	dataEntryTimeStamp = [datePickerView.date copy];
	
	[formTableView reloadData];
}


- (void)didTapKeyPad:(KeyPadViewController *)keyPad onKey:(NSString *)key {
	NSMutableString *valueString = [[NSMutableString alloc] initWithString:[dataEntryValue stringValue]];
	
	if ([key isEqualToString:@"⌫"]) {
		NSRange range = [valueString rangeOfString:@"."];
		
		if (valueFormatter.alwaysShowsDecimalSeparator & range.location == NSNotFound) {
			[valueFormatter setAlwaysShowsDecimalSeparator:NO];
		} else if ([valueString length] > 1) {
			[valueString deleteCharactersInRange:NSMakeRange([valueString length] - 1, 1)];
		} else {
			[valueString release];
			valueString = [[NSMutableString alloc] initWithString:@"0"];
		}
	} else if ([key isEqualToString:@"C"]) {
		[valueString release];
		valueString = [[NSMutableString alloc] initWithString:@"0"];
		[valueFormatter setAlwaysShowsDecimalSeparator:NO];
	} else if ([key isEqualToString:@"±"]) {
		if ([valueString hasPrefix:@"-"]) {
			[valueString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
		} else {
			[valueString insertString:@"-" atIndex:0];
		}
	} else if ([key isEqualToString:@"."]) {
		[valueFormatter setAlwaysShowsDecimalSeparator:YES];
	} else {
		if ([[valueString substringToIndex:1] isEqualToString:@"0"] & !valueFormatter.alwaysShowsDecimalSeparator) {
			[valueString replaceCharactersInRange:NSMakeRange(0, 1) withString:key];
		} else {
			if (valueFormatter.alwaysShowsDecimalSeparator) {
				NSRange range = [valueString rangeOfString:@"."];
				
				if (range.location == NSNotFound) {
					[valueString appendString:@"."];
				}
			}
			
			[valueString appendString:key];
		}
	}
	
	[dataEntryValue release];
	dataEntryValue = [[NSNumber alloc] initWithFloat:[valueString floatValue]];
	
	[valueString release];
	[formTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[dataItem release];
	[dataEntry release];
	[dataEntryValue release];
	[valueFormatter release];
	[dataEntryTimeStamp release];
	[dateFormatter release];
	[formTableView release];
	[datePickerView release];
	[keyPad release];
    [super dealloc];
}

@end
