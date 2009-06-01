//
//  FlipsideViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "SquirrelAppDelegate.h"
#import "FlipsideViewController.h"
#import "DataSet.h"
#import "DataSetViewController.h"


@implementation FlipsideViewController

@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Settings";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView reloadData];
}


- (void)save:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSMutableArray *dataSets = [(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets];
    
	if (indexPath.row == [dataSets count]) {
		cell.text = @"Add a new data set";
	} else {
		DataSet *dataSet = [dataSets objectAtIndex:indexPath.row];
		cell.text = dataSet.name;
	}

    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Data Sets";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DataSet *dataSet;
	
	if (indexPath.row == [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count]) {
		dataSet = [[[DataSet alloc] init] autorelease];
	} else {
		dataSet = [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:indexPath.row];
	}

	DataSetViewController *controller = [[DataSetViewController alloc] initWithStyle:UITableViewStyleGrouped];

	controller.dataSet = dataSet;
	
	[self.navigationController pushViewController:controller animated:YES];
	
	[controller release];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count]) {
		return UITableViewCellEditingStyleInsert;
	} else {
		return UITableViewCellEditingStyleDelete;
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		SquirrelAppDelegate *appDelegate = (SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate];
		DataSet *dataSet = [[appDelegate dataSets] objectAtIndex:indexPath.row];
		
		[appDelegate removeDataSet:dataSet];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

}


- (void)dealloc {
    [super dealloc];
}


@end
