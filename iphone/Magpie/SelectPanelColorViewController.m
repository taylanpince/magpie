//
//  SelectPanelColorViewController.m
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SelectPanelColorViewController.h"
#import "InfoTableViewCell.h"


@implementation SelectPanelColorViewController

@synthesize panelColor, panelColors, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (panelColors == nil) {
		panelColors = [[NSArray alloc] initWithObjects:
					   @"Blue", 
					   @"Green", 
					   @"Red", 
					   @"Cyan", 
					   @"Yellow", 
					   @"Purple", 
					   @"Gray", nil];
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
    
    InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[InfoTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if ([[panelColors objectAtIndex:indexPath.row] isEqualToString:panelColor]) {
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	} else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	
	[cell setMainLabel:[panelColors objectAtIndex:indexPath.row]];
	[cell setSubLabel:@""];
	[cell setIconType:@"Color"];
	[cell setIconColor:[panelColors objectAtIndex:indexPath.row]];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 56.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[delegate didUpdatePanelColor:[panelColors objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	[panelColor release];
	[panelColors release];
    [super dealloc];
}

@end