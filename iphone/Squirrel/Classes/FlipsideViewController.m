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
#import "DataPanel.h"
#import "DataSetViewController.h"
#import "DataPanelViewController.h"


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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count] + 1;
	} else {
		return [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count] + 1;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	if (indexPath.section == 0) {
		NSMutableArray *dataSets = [(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets];
		
		if (indexPath.row == [dataSets count]) {
			cell.text = @"Add a new data set";
		} else {
			DataSet *dataSet = [dataSets objectAtIndex:indexPath.row];
			cell.text = dataSet.name;
		}
	} else {
		NSMutableArray *dataPanels = [(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels];
		
		if (indexPath.row == [dataPanels count]) {
			cell.text = @"Add a new data panel";
		} else {
			DataPanel *dataPanel = [dataPanels objectAtIndex:indexPath.row];
			cell.text = dataPanel.name;
		}
	}

    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Data Sets" : @"Data Panels";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
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
	} else {
		DataPanel *dataPanel;
		
		if (indexPath.row == [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]) {
			dataPanel = [[[DataPanel alloc] init] autorelease];
		} else {
			dataPanel = [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] objectAtIndex:indexPath.row];
		}
		
		DataPanelViewController *controller = [[DataPanelViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		controller.dataPanel = dataPanel;
		
		[self.navigationController pushViewController:controller animated:YES];
		
		[controller release];
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count]) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
	} else {
		if (indexPath.row == [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (indexPath.section == 0) {
			SquirrelAppDelegate *appDelegate = (SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate];
			DataSet *dataSet = [[appDelegate dataSets] objectAtIndex:indexPath.row];
			
			[appDelegate removeDataSet:dataSet];
			
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		} else {
			SquirrelAppDelegate *appDelegate = (SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate];
			DataPanel *dataPanel = [[appDelegate dataPanels] objectAtIndex:indexPath.row];
			
			[appDelegate removeDataPanel:dataPanel];
			
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
    }   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}


@end
