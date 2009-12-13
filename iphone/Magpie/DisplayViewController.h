//
//  DisplayViewController.h
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "EditableTableViewCell.h"
#import "SelectCategoryViewController.h"
#import "SelectPanelTypeViewController.h"
#import "SelectPanelColorViewController.h"

@class Display;

@interface DisplayViewController : UITableViewController <EditableTableViewCellDelegate, SelectCategoryViewControllerDelegate, SelectPanelTypeViewControllerDelegate, SelectPanelColorViewControllerDelegate> {
	Display *display;
	
	NSManagedObjectContext *managedObjectContext;
	
	UITextField *activeTextField;
}

@property (nonatomic, retain) Display *display;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) UITextField *activeTextField;

@end