//
//  DisplayViewController.m
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "DisplayViewController.h"
#import "EditableTableViewCell.h"
#import	"SelectableTableViewCell.h"
#import "SelectCategoryViewController.h"
#import "SelectPanelTypeViewController.h"
#import "SelectPanelColorViewController.h"
#import "Display.h"
#import "Category.h"


@implementation DisplayViewController

@synthesize display, activeTextField;
@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
	
	if (display != nil) {
		[self setTitle:display.name];
	} else {
		self.display = (Display *)[NSEntityDescription insertNewObjectForEntityForName:@"Display" inManagedObjectContext:managedObjectContext];
		
		[self setTitle:@"New Display"];
		[saveButton setEnabled:NO];
	}
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)save:(id)sender {
	if (activeTextField) {
		[activeTextField resignFirstResponder];
	}
	
	NSError *error;
	
	if (![managedObjectContext save:&error]) {
		// TODO: Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
	
	// TODO: Make delegate call so context can be merged
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender {
	// TODO: Make delegate call to cancel
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		static NSString *CellIdentifier = @"Cell";
		
		EditableTableViewCell *cell = (EditableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[EditableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		}
		
		[cell setDelegate:self];
		[cell setIndexPath:indexPath];
		[cell.textField setText:display.name];
		
		return cell;
	} else {
		static NSString *CellIdentifier = @"SelectCell";
		
		SelectableTableViewCell *cell = (SelectableTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[[SelectableTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		
		switch (indexPath.row) {
			case 1:
				[cell.titleLabel setText:@"Category"];
				
				if (display.category) {
					[cell.dataLabel setText:display.category.name];
					[cell setBlank:NO];
				} else {
					[cell.dataLabel setText:@"Select a Category"];
					[cell setBlank:YES];
				}
				
				break;
			case 2:
				[cell.titleLabel setText:@"Type"];
				
				if (display.type) {
					[cell.dataLabel setText:display.type];
					[cell setBlank:NO];
				} else {
					[cell.dataLabel setText:@"Select a Display Type"];
					[cell setBlank:YES];
				}
				
				break;
			case 3:
				[cell.titleLabel setText:@"Color"];
				
				if (display.color) {
					[cell.dataLabel setText:display.color];
					[cell setBlank:NO];
				} else {
					[cell.dataLabel setText:@"Select a Color"];
					[cell setBlank:YES];
				}
				
				break;
			default:
				break;
		}
		
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case 1: {
			SelectCategoryViewController *controller = [[SelectCategoryViewController alloc] initWithStyle:UITableViewStyleGrouped];
			
			[controller setCategory:display.category];
			[controller setManagedObjectContext:managedObjectContext];
			[controller setDelegate:self];
			
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
			
			break;
		}
		case 2: {
			SelectPanelTypeViewController *controller = [[SelectPanelTypeViewController alloc] initWithStyle:UITableViewStyleGrouped];
			
			[controller setPanelType:display.type];
			[controller setDelegate:self];
			
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
			
			break;
		}
		case 3: {
			SelectPanelColorViewController *controller = [[SelectPanelColorViewController alloc] initWithStyle:UITableViewStyleGrouped];
			
			[controller setPanelColor:display.color];
			[controller setDelegate:self];
			
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
			
			break;
		}
		default:
			break;
	}
}

- (void)didBeginEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withTextField:(UITextField *)field {
	activeTextField = field;
}

- (void)didEndEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	[display setName:newValue];
}

- (void)didChangeEditingTextFieldAtIndexPath:(NSIndexPath *)indexPath withValue:(NSString *)newValue {
	if ([newValue isEqualToString:@""]) {
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	} else if (display.type && display.category) {
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
}

- (void)didUpdateCategory:(Category *)newCategory {
	[self.display setCategory:newCategory];
	[self.tableView reloadData];
	
	if (![self.display.name isEqualToString:@""] && ![self.display.type isEqualToString:@""]) {
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	}
}

- (void)didUpdatePanelType:(NSMutableString *)newPanelType {
	if (![display.type isEqualToString:newPanelType]) {
		[self.display setType:newPanelType];
		[self.tableView reloadData];
		
		if (![self.display.name isEqualToString:@""] && self.display.category != nil) {
			[self.navigationItem.rightBarButtonItem setEnabled:YES];
		}
	}
}

- (void)didUpdatePanelColor:(NSMutableString *)newPanelColor {
	if (![self.display.color isEqualToString:newPanelColor]) {
		[self.display setColor:newPanelColor];
		[self.tableView reloadData];
		
		if (![self.display.name isEqualToString:@""] && self.display.type != nil && self.display.category != nil) {
			[self.navigationItem.rightBarButtonItem setEnabled:YES];
		}
	}
}

- (void)dealloc {
	[display release];
	[managedObjectContext release];
    [super dealloc];
}

@end