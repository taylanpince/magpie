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

@protocol DisplayViewControllerDelegate;

@interface DisplayViewController : UITableViewController <EditableTableViewCellDelegate, SelectCategoryViewControllerDelegate, SelectPanelTypeViewControllerDelegate, SelectPanelColorViewControllerDelegate> {
	Display *display;
	
	NSManagedObjectContext *managedObjectContext;
	
	UITextField *activeTextField;
	
	id <DisplayViewControllerDelegate> delegate;
}

@property (nonatomic, retain) Display *display;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) UITextField *activeTextField;

@property (nonatomic, assign) id <DisplayViewControllerDelegate> delegate;

@end

@protocol DisplayViewControllerDelegate
- (void)displayViewController:(DisplayViewController *)controller didFinishWithSave:(BOOL)save inScratch:(BOOL)scratch;
@end