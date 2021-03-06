//
//  FlipsideViewController.m
//  Magpie
//
//  Created by Taylan Pince on 29/05/09.
//  Copyright Taylan Pince 2009. All rights reserved.
//

#import "MagpieAppDelegate.h"
#import "FlipsideViewController.h"
#import "DataSet.h"
#import "DataPanel.h"
#import "DataSetViewController.h"
#import "DataPanelViewController.h"
#import "InfoTableViewCell.h"
#import "HelpView.h"


@implementation FlipsideViewController

@synthesize delegate, helpView;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Settings";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	helpView = nil;
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (helpView != nil) {
		[helpView removeFromSuperview];
		[helpView release];
		
		helpView = nil;
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[self.tableView reloadData];
	
	NSMutableArray *dataSets = [(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets];
	NSMutableArray *dataPanels = [(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels];
	
	if ([dataSets count] == 0) {
		helpView = [[HelpView alloc] initWithFrame:CGRectMake(100.0, 120.0, 200.0, 170.0)];
		
		[helpView setAlpha:0.0];
		[helpView setHelpText:@"You should define a Category first. Categories are collections of Items, and each Item contains Entries. Tap on Add a new Category to continue."];
		[helpView setHelpBubbleCorner:2];
		
		[self.view addSubview:helpView];
		
		[UIView beginAnimations:@"fadeInHelp" context:NULL];
		[helpView setAlpha:1.0];
		[helpView setFrame:CGRectMake(100.0, 80.0, 200.0, 170.0)];
		[UIView commitAnimations];
	} else if ([dataPanels count] == 0) {
		helpView = [[HelpView alloc] initWithFrame:CGRectMake(100.0, 250.0, 200.0, 135.0)];
		
		[helpView setAlpha:0.0];
		[helpView setHelpText:@"Add a Display to visualize the Category you created. Tap on Add a new Display to continue."];
		[helpView setHelpBubbleCorner:2];
		
		[self.view addSubview:helpView];
		
		[UIView beginAnimations:@"fadeInHelp" context:NULL];
		[helpView setAlpha:1.0];
		[helpView setFrame:CGRectMake(100.0, 210.0, 200.0, 135.0)];
		[UIView commitAnimations];
	}
}


- (void)save:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count] + 1;
	} else {
		return [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count] + 1;
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
		NSMutableArray *dataSets = [(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets];
		
		if (indexPath.row == [dataSets count]) {
			cell.mainLabel = @"Add a new Category";
			cell.subLabel = @"";
			cell.iconType = @"";
		} else {
			DataSet *dataSet = [dataSets objectAtIndex:indexPath.row];
			cell.mainLabel = dataSet.name;
			cell.subLabel = @"";
			cell.iconType = @"";
		}
	} else {
		NSMutableArray *dataPanels = [(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels];
		
		if (indexPath.row == [dataPanels count]) {
			cell.mainLabel = @"Add a new Display";
			cell.subLabel = @"";
			cell.iconType = @"";
		} else {
			DataPanel *dataPanel = [dataPanels objectAtIndex:indexPath.row];
			cell.mainLabel = dataPanel.name;
			cell.subLabel = [NSString stringWithFormat:@"%@, %@", dataPanel.type, dataPanel.dataSet.name];
			cell.iconType = dataPanel.type;
			cell.iconColor = dataPanel.color;
		}
	}

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray *dataPanels = [(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels];
	NSMutableArray *dataSets = [(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets];
	
	if (indexPath.section == 1 && indexPath.row < [dataPanels count]) {
		DataPanel *dataPanel = [dataPanels objectAtIndex:indexPath.row];
		
		UIFont *mainFont = [UIFont boldSystemFontOfSize:16];
		UIFont *subFont = [UIFont systemFontOfSize:12];

		CGSize mainLabelSize = [dataPanel.name sizeWithFont:mainFont constrainedToSize:CGSizeMake(221.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		CGSize subLabelSize = [[NSString stringWithFormat:@"%@, %@", dataPanel.type, dataPanel.dataSet.name] sizeWithFont:subFont constrainedToSize:CGSizeMake(221.0, 20.0) lineBreakMode:UILineBreakModeTailTruncation];
		
		return mainLabelSize.height + subLabelSize.height + 25.0;
	} else if (indexPath.section == 0 && indexPath.row < [dataSets count]) {
		DataSet *dataSet = [dataSets objectAtIndex:indexPath.row];
		
		UIFont *mainFont = [UIFont boldSystemFontOfSize:16];
		
		CGSize mainLabelSize = [dataSet.name sizeWithFont:mainFont constrainedToSize:CGSizeMake(255.0, 600.0) lineBreakMode:UILineBreakModeWordWrap];
		
		return mainLabelSize.height + 20.0;
	} else {
		return 42.0;
	}
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Categories" : @"Displays";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		DataSet *dataSet;
		
		if (indexPath.row == [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count]) {
			dataSet = [[[DataSet alloc] init] autorelease];
		} else {
			dataSet = [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:indexPath.row];
		}

		DataSetViewController *controller = [[DataSetViewController alloc] initWithStyle:UITableViewStyleGrouped];

		controller.dataSet = dataSet;
		
		[self.navigationController pushViewController:controller animated:YES];
		
		[controller release];
	} else {
		DataPanel *dataPanel;
		
		if (indexPath.row == [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]) {
			dataPanel = [[[DataPanel alloc] init] autorelease];
		} else {
			dataPanel = [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] objectAtIndex:indexPath.row];
		}
		
		DataPanelViewController *controller = [[DataPanelViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		controller.dataPanel = dataPanel;
		
		[self.navigationController pushViewController:controller animated:YES];
		
		[controller release];
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		if (indexPath.row == [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count]) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
	} else {
		if (indexPath.row == [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]) {
			return UITableViewCellEditingStyleInsert;
		} else {
			return UITableViewCellEditingStyleDelete;
		}
	}
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		if (indexPath.section == 0) {
			MagpieAppDelegate *appDelegate = (MagpieAppDelegate *)[[UIApplication sharedApplication] delegate];
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
			MagpieAppDelegate *appDelegate = (MagpieAppDelegate *)[[UIApplication sharedApplication] delegate];
			DataPanel *dataPanel = [[appDelegate dataPanels] objectAtIndex:indexPath.row];
			
			[appDelegate removeDataPanel:dataPanel];
			
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
		[self tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == 1 & indexPath.row < [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]);
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	MagpieAppDelegate *appDelegate = (MagpieAppDelegate *)[[UIApplication sharedApplication] delegate];
	DataPanel *dataPanel = [[[appDelegate dataPanels] objectAtIndex:fromIndexPath.row] retain];
	
	[[appDelegate dataPanels] removeObjectAtIndex:fromIndexPath.row];
	[[appDelegate dataPanels] insertObject:dataPanel atIndex:toIndexPath.row];
	
	[appDelegate reorderDataPanels];
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	if (proposedDestinationIndexPath.section == 0) {
		return [NSIndexPath indexPathForRow:0 inSection:1];
	} else if (proposedDestinationIndexPath.row >= [[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count]) {
		return [NSIndexPath indexPathForRow:([[(MagpieAppDelegate *)[[UIApplication sharedApplication] delegate] dataPanels] count] - 1) inSection:1];
	} else {
		return proposedDestinationIndexPath;
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	if (helpView != nil) {
		[helpView release];
	}

    [super dealloc];
}


@end
