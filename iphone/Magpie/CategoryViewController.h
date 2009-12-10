//
//  CategoryViewController.h
//  Magpie
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "EditableTableViewCell.h"

@class Category;

@interface CategoryViewController : UITableViewController <EditableTableViewCellDelegate> {
	Category *category;
	
	NSManagedObjectContext *managedObjectContext;
	
	UITextField *activeTextField;
}

@property (nonatomic, retain) Category *category;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) UITextField *activeTextField;

@end