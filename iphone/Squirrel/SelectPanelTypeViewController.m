//
//  SelectPanelTypeViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SelectPanelTypeViewController.h"


@implementation SelectPanelTypeViewController

@synthesize panelType, panelTypes, delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (panelTypes == nil) {
		panelTypes = [[NSArray alloc] initWithObjects:@"Pie Chart", @"Bar Chart", nil];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if ([[panelTypes objectAtIndex:indexPath.row] isEqualToString:panelType]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	cell.text = [panelTypes objectAtIndex:indexPath.row];
	
    return cell;
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