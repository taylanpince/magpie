//
//  SelectPanelColorViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SelectPanelColorViewController.h"


@implementation SelectPanelColorViewController

@synthesize panelColor, panelColors, delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (panelColors == nil) {
		panelColors = [[NSArray alloc] initWithObjects:@"Blue", @"Green", @"Red", nil];
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
    return [panelColors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if ([[panelColors objectAtIndex:indexPath.row] isEqualToString:panelColor]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	cell.text = [panelColors objectAtIndex:indexPath.row];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[delegate didUpdatePanelColor:[panelColors objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
	[panelColors release];
    [super dealloc];
}


@end
