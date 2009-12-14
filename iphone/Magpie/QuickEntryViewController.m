//
//  QuickEntryViewController.m
//  Magpie
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "QuickEntryViewController.h"
#import "ScreenTableViewCell.h"
#import "SubScreenTableViewCell.h"
#import "KeyPadViewController.h"
#import "Category.h"
#import "Entry.h"
#import "Item.h"


@implementation QuickEntryViewController

@synthesize entry, item, managedObjectContext, categoriesList;
@synthesize formTableView, datePickerView, dataSetPicker, keyPad;
@synthesize activeRow, dateFormatter, valueFormatter, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	if (dateFormatter) [dateFormatter release];
	if (valueFormatter) [valueFormatter release];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	valueFormatter = [[NSNumberFormatter alloc] init];
	
	[valueFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[valueFormatter setMaximumFractionDigits:4];
	[valueFormatter setGeneratesDecimalNumbers:NO];
	
	if (entry != nil) {
		[self setTitle:@"Edit Entry"];
	} else {
		self.entry = (Entry *)[NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:managedObjectContext];
		
		[entry setTimeStamp:[NSDate date]];
		[entry setItem:item];
		
		[self setTitle:@"Add Entry"];
		
		[saveButton setEnabled:NO];
	}
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
	
	[formTableView setBackgroundColor:[UIColor colorWithRed:0.34 green:0.35 blue:0.37 alpha:1.0]];
	[self.view setBackgroundColor:[UIColor darkGrayColor]];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
	
	[request setEntity:entity];
	[request setSortDescriptors:sorters];
	
	[sorter release];
	[sorters release];
	
	NSError *error;
	NSMutableArray *results = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (results == nil) {
		// TODO: Handle the error
	}
	
	[self setCategoriesList:results];
	[results release];
	[request release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	[formTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	[self tableView:formTableView didSelectRowAtIndexPath:indexPath];
}

- (void)save:(id)sender {
	NSError *error;
	
	if (![managedObjectContext save:&error]) {
		// TODO: Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
	
	if (delegate) {
		[delegate didCloseQuickEntryView];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)cancel:(id)sender {
	if (delegate) {
		[delegate didCloseQuickEntryView];
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
		cell.valueLabel.text = [valueFormatter stringFromNumber:entry.value];
		
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
			cell.dataLabel.text = [dateFormatter stringFromDate:entry.timeStamp];
		} else if (indexPath.row == 2) {
			cell.titleLabel.text = @"ITEM";
			cell.dataLabel.text = [NSString stringWithFormat:@"%@ → %@", item.category.name, item.name];
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
				[datePickerView setDate:entry.timeStamp];
				
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
				[dataSetPicker selectRow:[categoriesList indexOfObject:item.category] inComponent:0 animated:NO];
				[dataSetPicker selectRow:[[item.category.items allObjects] indexOfObject:item] inComponent:1 animated:NO];
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
	[entry setTimeStamp:datePickerView.date];
	[formTableView reloadData];
}

- (void)didTapKeyPad:(KeyPadViewController *)keyPad onKey:(NSInteger)key {
	NSMutableString *valueString = [[NSMutableString alloc] initWithString:[entry.value stringValue]];
	
	if (key == 14) {
		NSRange range = [valueString rangeOfString:@"."];
		
		if (valueFormatter.alwaysShowsDecimalSeparator && range.location == NSNotFound) {
			[valueFormatter setAlwaysShowsDecimalSeparator:NO];
			[valueFormatter setMinimumFractionDigits:0];
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
		[valueFormatter setMinimumFractionDigits:0];
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
		
		if ([[valueString substringToIndex:1] isEqualToString:@"0"] && !valueFormatter.alwaysShowsDecimalSeparator) {
			[valueString replaceCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"%d", key]];
		} else {
			if (valueFormatter.alwaysShowsDecimalSeparator) {
				NSRange range = [valueString rangeOfString:@"."];
				
				if (range.location == NSNotFound) {
					[valueString appendString:@"."];
				}
			}
			
			if (key == 0 && valueFormatter.alwaysShowsDecimalSeparator) {
				[valueFormatter setMinimumFractionDigits:valueFormatter.minimumFractionDigits + 1];
			} else if (valueFormatter.minimumFractionDigits > 0) {
				for (NSUInteger i = 0; i < valueFormatter.minimumFractionDigits; i++) {
					[valueString appendString:@"0"];
				}
				
				[valueString appendString:[NSString stringWithFormat:@"%d", key]];
			} else {
				[valueString appendString:[NSString stringWithFormat:@"%d", key]];
			}
		}
	}
	
	[entry setValue:[[NSNumber alloc] initWithDouble:[valueString doubleValue]]];
	
	if ([entry.value doubleValue] == 0.0) {
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
	NSInteger total = 0;
	
	switch (component) {
		case 0: {
			total = [categoriesList count];
			
			break;
		}
		case 1: {
			NSInteger selectedRow = [pickerView selectedRowInComponent:0];

			if (selectedRow >= 0) {
				total = [[[categoriesList objectAtIndex:selectedRow] items] count];
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
			title = [[categoriesList objectAtIndex:row] name];

			break;
		}
		case 1: {
			NSInteger selectedRow = [pickerView selectedRowInComponent:0];
			
			if (selectedRow >= 0) {
				Category *category = [categoriesList objectAtIndex:selectedRow];
				
				title = [[[category.items allObjects] objectAtIndex:row] name];
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
			
			Item *newItem = [[[(Category *)[categoriesList objectAtIndex:row] items] allObjects] objectAtIndex:[pickerView selectedRowInComponent:1]];
			
			if (newItem != nil) {
				[self setItem:newItem];
				
				[formTableView reloadData];
			}
			
			break;
		}
		case 1: {
			Item *newItem = [[[(Category *)[categoriesList objectAtIndex:[pickerView selectedRowInComponent:0]] items] allObjects] objectAtIndex:row];

			if (newItem != nil) {
				[self setItem:newItem];
				
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
	[item release];
	[entry release];
	[managedObjectContext release];
	[valueFormatter release];
	[dateFormatter release];
	[formTableView release];
	[datePickerView release];
	[dataSetPicker release];
	[keyPad release];
    [super dealloc];
}

@end