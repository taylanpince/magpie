//
//  DataEntryViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "DataEntryViewController.h"
#import "EditDataEntryViewController.h"
#import "InfoTableViewCell.h"
#import "DataItem.h"
#import "DataEntry.h"


@implementation DataEntryViewController

@synthesize dataItem, dateFormatter, valueFormatter, delegate;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = dataItem.name;
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	if (dateFormatter) [dateFormatter release];
	if (valueFormatter) [valueFormatter release];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	valueFormatter = [[NSNumberFormatter alloc] init];
	[valueFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	[self.navigationItem setRightBarButtonItem:doneButton];
	[doneButton release];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView reloadData];
}


- (void)done:(id)sender {
	[delegate didCloseDataEntryView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dataItem.dataEntries count] + 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Data Entries";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[InfoTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	if (indexPath.row == 0) {
		cell.mainLabel.text = @"Add New Data Entry";
	} else {
		DataEntry *dataEntry = [dataItem.dataEntries objectAtIndex:(indexPath.row - 1)];

		cell.mainLabel.text = [valueFormatter stringFromNumber:dataEntry.value];
		cell.subLabel.text = [dateFormatter stringFromDate:dataEntry.timeStamp];
	}
	
	return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.row == 0) ? 42.0 : 56.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DataEntry *dataEntry;
	
	if (indexPath.row == 0) {
		dataEntry = [[[DataEntry alloc] init] autorelease];
	} else {
		dataEntry = [dataItem.dataEntries objectAtIndex:(indexPath.row - 1)];
	}
	
	EditDataEntryViewController *controller = [[EditDataEntryViewController alloc] initWithNibName:@"DataEntryView" bundle:nil];
	
	controller.dataEntry = dataEntry;
	controller.dataItem = dataItem;
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		DataEntry *dataEntry = [dataItem.dataEntries objectAtIndex:(indexPath.row - 1)];
		
		[dataItem removeDataEntry:dataEntry];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}


- (void)dealloc {
	[dataItem release];
	[dateFormatter release];
	[valueFormatter release];
    [super dealloc];
}

@end
