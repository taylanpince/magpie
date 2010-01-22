//
//  SelectPanelTypeViewController.m
//  Magpie
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
					  @"Daily Timeline", 
					  @"Monthly Timeline", 
					  @"Latest Entry as Words", 
					  @"Latest Entry as Numbers", 
					  @"Largest Entry as Words", 
					  @"Largest Entry as Numbers", 
					  @"Latest Entry Type", 
					  @"Largest Entry Type", 
					  @"Average Entry as Words", 
					  @"Average Entry as Numbers", 
					  @"Total as Words", 
					  @"Total as Numbers", 
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
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	} else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	
	[cell setMainLabel:[panelTypes objectAtIndex:indexPath.row]];
	[cell setSubLabel:@""];
	[cell setIconType:[panelTypes objectAtIndex:indexPath.row]];
	
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
	[panelType release];
	[panelTypes release];
    [super dealloc];
}

@end