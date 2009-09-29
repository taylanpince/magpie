//
//  EditDataEntryViewController.m
//  Magpie
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "MagpieAppDelegate.h"
#import "EditDataEntryViewController.h"
#import "ScreenTableViewCell.h"
#import "SubScreenTableViewCell.h"
#import "KeyPadViewController.h"
#import "DataSet.h"
#import "DataEntry.h"
#import "DataItem.h"


@implementation EditDataEntryViewController

@synthesize dataEntry, dataItem, formTableView, datePickerView, dataSetPicker, keyPad, dataEntryValue, dataEntryTimeStamp;
@synthesize activeRow, dateFormatter, valueFormatter, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	[saveButton setEnabled:NO];
	
	if (dataEntryValue) [dataEntryValue release];
	if (dataEntryTimeStamp) [dataEntryTimeStamp release];
	if (dateFormatter) [dateFormatter release];
	if (valueFormatter) [valueFormatter release];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	valueFormatter = [[NSNumberFormatter alloc] init];
	[valueFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	if (dataEntry.primaryKey) {
		self.title = @"Edit Entry";
		
		dataEntryValue = [dataEntry.value copy];
		dataEntryTimeStamp = [dataEntry.timeStamp copy];
	} else {
		self.title = @"Add Entry";
		
		dataEntryValue = [[NSNumber alloc] initWithDouble:0.0];
		dataEntryTimeStamp = [[NSDate alloc] init];
	}
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
	
	[formTableView setBackgroundColor:[UIColor colorWithRed:0.34 green:0.35 blue:0.37 alpha:1.0]];
	
	[self.view setBackgroundColor:[UIColor darkGrayColor]];
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
	} else {
		[dataEntry dehydrate];
	}
	
	dataItem.lastUpdated = [NSDate date];
	[dataItem dehydrate];
	[dataItem selectRelated];
	
	if (delegate) {
		[delegate didCloseEditDataEntryView];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}


- (void)cancel:(id)sender {
	if (delegate) {
		[delegate didCloseEditDataEntryView];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	if (indexPath.row == 0) {
		ScreenTableViewCell *cell = (ScreenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[ScreenTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		cell.active = (activeRow == indexPath.row);
		cell.valueLabel.text = [valueFormatter stringFromNumber:dataEntryValue];
		
		return cell;
	} else {
		SubScreenTableViewCell *cell = (SubScreenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[SubScreenTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		cell.active = (activeRow == indexPath.row);

		if (indexPath.row == 1) {
			cell.titleLabel.text = @"DATE/TIME";
			cell.dataLabel.text = [dateFormatter stringFromDate:dataEntryTimeStamp];
		} else if (indexPath.row == 2) {
			cell.titleLabel.text = @"ITEM";
			cell.dataLabel.text = [NSString stringWithFormat:@"%@ → %@", dataItem.dataSet.name, dataItem.name];
		}
		
		return cell;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.row == 0) ? 82.0 : 59.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	activeRow = indexPath.row;
	
	switch (indexPath.row) {
		case 0: {
			if (!keyPad) {
				keyPad = [[KeyPadViewController alloc] initWithNibName:@"KeyPadView" bundle:nil];
				
				[keyPad setDelegate:self];
				[keyPad.view setFrame:CGRectMake(0.0, 460.0, self.view.frame.size.width, 216.0)];
				
				[self.view addSubview:keyPad.view];
			}
			
			[UIView beginAnimations:@"moveKeyPads" context:nil];
			[keyPad.view setFrame:CGRectMake(0.0, 200.0, keyPad.view.frame.size.width, keyPad.view.frame.size.height)];
			[datePickerView setFrame:CGRectMake(0.0, 460.0, datePickerView.frame.size.width, datePickerView.frame.size.height)];
			[dataSetPicker setFrame:CGRectMake(0.0, 460.0, dataSetPicker.frame.size.width, dataSetPicker.frame.size.height)];
			[UIView commitAnimations];

			break;
		}
		case 1: {
			if (!datePickerView) {
				datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 460.0, self.view.frame.size.width, 216.0)];
				
				[datePickerView addTarget:self action:@selector(didSelectDate:) forControlEvents:UIControlEventValueChanged];
				[datePickerView setDate:dataEntryTimeStamp];
				
				[self.view addSubview:datePickerView];
			}

			[UIView beginAnimations:@"moveKeyPads" context:nil];
			[datePickerView setFrame:CGRectMake(0.0, 200.0, datePickerView.frame.size.width, datePickerView.frame.size.height)];
			[keyPad.view setFrame:CGRectMake(0.0, 460.0, keyPad.view.frame.size.width, keyPad.view.frame.size.height)];
			[dataSetPicker setFrame:CGRectMake(0.0, 460.0, dataSetPicker.frame.size.width, dataSetPicker.frame.size.height)];
			[UIView commitAnimations];

			break;
		}
		case 2: {
			if (!dataSetPicker) {
				dataSetPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 460.0, self.view.frame.size.width, 216.0)];
				
				[dataSetPicker setDelegate:self];
				[dataSetPicker setDataSource:self];
				[dataSetPicker setShowsSelectionIndicator:YES];
				
				[dataSetPicker selectRow:[[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] indexOfObject:dataItem.dataSet] inComponent:0 animated:NO];
				[dataSetPicker selectRow:[dataItem.dataSet.dataItems indexOfObject:dataItem] inComponent:1 animated:NO];
				[dataSetPicker reloadComponent:1];
				
				[self.view addSubview:dataSetPicker];
			}

			[UIView beginAnimations:@"moveKeyPads" context:nil];
			[dataSetPicker setFrame:CGRectMake(0.0, 200.0, dataSetPicker.frame.size.width, dataSetPicker.frame.size.height)];
			[keyPad.view setFrame:CGRectMake(0.0, 460.0, keyPad.view.frame.size.width, keyPad.view.frame.size.height)];
			[datePickerView setFrame:CGRectMake(0.0, 460.0, datePickerView.frame.size.width, datePickerView.frame.size.height)];
			[UIView commitAnimations];

			break;
		}
	}
	
	[formTableView reloadData];
}


- (void)didSelectDate:(id)sender {
	[dataEntryTimeStamp release];
	
	dataEntryTimeStamp = [datePickerView.date copy];
	
	[formTableView reloadData];
}


- (void)didTapKeyPad:(KeyPadViewController *)keyPad onKey:(NSInteger)key {
	NSMutableString *valueString = [[NSMutableString alloc] initWithString:[dataEntryValue stringValue]];
	
	if (key == 14) {
		NSRange range = [valueString rangeOfString:@"."];
		
		if (valueFormatter.alwaysShowsDecimalSeparator & range.location == NSNotFound) {
			[valueFormatter setAlwaysShowsDecimalSeparator:NO];
		} else if ([valueString length] > 1) {
			[valueString deleteCharactersInRange:NSMakeRange([valueString length] - 1, 1)];
		} else {
			[valueString release];
			valueString = [[NSMutableString alloc] initWithString:@"0"];
		}
	} else if (key == 12) {
		[valueString release];
		valueString = [[NSMutableString alloc] initWithString:@"0"];
		[valueFormatter setAlwaysShowsDecimalSeparator:NO];
	} else if (key == 13) {
		if ([valueString hasPrefix:@"-"]) {
			[valueString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
		} else {
			[valueString insertString:@"-" atIndex:0];
		}
	} else if (key == 11) {
		[valueFormatter setAlwaysShowsDecimalSeparator:YES];
	} else {
		if (key == 10) key = 0;
		
		if ([[valueString substringToIndex:1] isEqualToString:@"0"] & !valueFormatter.alwaysShowsDecimalSeparator) {
			[valueString replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d", key]];
		} else {
			if (valueFormatter.alwaysShowsDecimalSeparator) {
				NSRange range = [valueString rangeOfString:@"."];
				
				if (range.location == NSNotFound) {
					[valueString appendString:@"."];
				}
			}
			
			[valueString appendString:[NSString stringWithFormat:@"%d", key]];
		}
	}
	
	[dataEntryValue release];
	dataEntryValue = [[NSNumber alloc] initWithDouble:[valueString doubleValue]];
	
	if ([dataEntryValue doubleValue] == 0.0) {
		[[self.navigationItem rightBarButtonItem] setEnabled:NO];
	} else {
		[[self.navigationItem rightBarButtonItem] setEnabled:YES];
	}
	
	[valueString release];
	[formTableView reloadData];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSInteger total;
	
	switch (component) {
		case 0: {
			total = [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count];
			
			break;
		}
		case 1: {
			NSInteger selectedRow = [pickerView selectedRowInComponent:0];

			if (selectedRow >= 0) {
				total = [[[[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:selectedRow] dataItems] count];
			} else {
				total = 0;
			}

			break;
		}
	}
	
	return total;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *title;
	
	switch (component) {
		case 0: {
			title = [[[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:row] name];

			break;
		}
		case 1: {
			NSInteger selectedRow = [pickerView selectedRowInComponent:0];
			
			if (selectedRow >= 0) {
				DataSet *activeSet = [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:selectedRow];
				
				title = [[activeSet.dataItems objectAtIndex:row] name];
			} else {
				title = @"";
			}
			
			break;
		}
	}
	
	return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	switch (component) {
		case 0: {
			[pickerView reloadComponent:1];
			
			DataItem *newDataItem = [[[[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:row] dataItems] objectAtIndex:[pickerView selectedRowInComponent:1]];
			
			if (newDataItem != nil) {
				[self setDataItem:newDataItem];
				[formTableView reloadData];
			}
			
			break;
		}
		case 1: {
			DataItem *newDataItem = [[[[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:[pickerView selectedRowInComponent:0]] dataItems] objectAtIndex:row];

			if (newDataItem != nil) {
				[self setDataItem:newDataItem];
				[formTableView reloadData];
			}
			
			break;
		}
	}
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
	[dataSetPicker release];
	[keyPad release];
    [super dealloc];
}

@end
