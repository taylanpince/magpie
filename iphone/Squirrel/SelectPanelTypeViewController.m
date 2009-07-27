//
//  SelectPanelTypeViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SelectPanelTypeViewController.h"
#import "InfoTableViewCell.h"


@implementation SelectPanelTypeViewController

@synthesize panelType, panelTypes, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (panelTypes == nil) {
		panelTypes = [[NSArray alloc] initWithObjects:
					  @"Pie Chart", 
					  @"Horizontal Bar Chart", 
					  @"Vertical Bar Chart", 
					  @"Latest Entry as Words", 
					  @"Latest Entry as Numbers", 
					  @"Latest Entry Type", 
					  @"Total as Words", 
					  @"Total as Numbers", 
					  @"Daily Timeline", 
					  @"Monthly Timeline", 
					  nil];
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [panelTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[InfoTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if ([[panelTypes objectAtIndex:indexPath.row] isEqualToString:panelType]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	
	cell.mainLabel = [panelTypes objectAtIndex:indexPath.row];
	cell.subLabel = @"";
	cell.iconType = [panelTypes objectAtIndex:indexPath.row];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[delegate didUpdatePanelType:[panelTypes objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	[panelTypes release];
    [super dealloc];
}

@end
