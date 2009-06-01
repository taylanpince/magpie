//
//  SelectDataSetViewController.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "SquirrelAppDelegate.h"
#import "SelectDataSetViewController.h"
#import "DataSet.h"


@implementation SelectDataSetViewController

@synthesize dataSet, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
	DataSet *cellDataSet = [[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:indexPath.row];
	
	if ([cellDataSet isEqualTo:dataSet]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	cell.text = cellDataSet.name;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[delegate didUpdateDataSet:[[(SquirrelAppDelegate *)[[UIApplication sharedApplication] delegate] dataSets] objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [super dealloc];
}


@end
