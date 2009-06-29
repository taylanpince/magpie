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
#import "InfoTableViewCell.h"


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
    
    InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[InfoTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	if (indexPath.section == 0) {
		NSMutableArray *dataSets = [(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets];
		
		if (indexPath.row == [dataSets count]) {
			cell.mainLabel.text = @"Add a new data set";
			cell.subLabel.text = @"";
		} else {
			DataSet *dataSet = [dataSets objectAtIndex:indexPath.row];
			cell.mainLabel.text = dataSet.name;
			cell.subLabel.text = @"";
		}
	} else {
		NSMutableArray *dataPanels = [(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels];
		
		if (indexPath.row == [dataPanels count]) {
			cell.mainLabel.text = @"Add a new data panel";
			cell.subLabel.text = @"";
		} else {
			DataPanel *dataPanel = [dataPanels objectAtIndex:indexPath.row];
			cell.mainLabel.text = dataPanel.name;
			cell.subLabel.text = [NSString stringWithFormat:@"%@, %@", dataPanel.type, dataPanel.dataSet.name];
		}
	}

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == 1 & indexPath.row < [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]) ? 56.0 : 42.0;
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
			
			NSMutableArray *deletedRows = [NSMutableArray arrayWithObject:indexPath];
			int rowNumber = 0;
			
			for (DataPanel *dataPanel in [appDelegate dataPanels]) {
				if (dataPanel.dataSet.primaryKey == dataSet.primaryKey) {
					[appDelegate removeDataPanel:dataPanel];
					[deletedRows addObject:[NSIndexPath indexPathForRow:rowNumber inSection:1]];
				}
				
				rowNumber++;
			}
			
			[appDelegate removeDataSet:dataSet];
			
			[tableView deleteRowsAtIndexPaths:deletedRows withRowAnimation:UITableViewRowAnimationFade];
		} else {
			SquirrelAppDelegate *appDelegate = (SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate];
			DataPanel *dataPanel = [[appDelegate dataPanels] objectAtIndex:indexPath.row];
			
			[appDelegate removeDataPanel:dataPanel];
			
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == 1 & indexPath.row < [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]);
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	SquirrelAppDelegate *appDelegate = (SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate];
	DataPanel *dataPanel = [[[appDelegate dataPanels] objectAtIndex:fromIndexPath.row] retain];
	
	[[appDelegate dataPanels] removeObjectAtIndex:fromIndexPath.row];
	[[appDelegate dataPanels] insertObject:dataPanel atIndex:toIndexPath.row];
	
	[appDelegate reorderDataPanels];
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	if (proposedDestinationIndexPath.section == 0) {
		return [NSIndexPath indexPathForRow:0 inSection:1];
	} else if (proposedDestinationIndexPath.row >= [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]) {
		return [NSIndexPath indexPathForRow:([[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count] - 1) inSection:1];
	} else {
		return proposedDestinationIndexPath;
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [super dealloc];
}


@end
