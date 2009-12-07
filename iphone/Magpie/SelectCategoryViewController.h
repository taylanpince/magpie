//
//  SelectCategoryViewController.h
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@protocol SelectCategoryViewControllerDelegate;

@class Category;

@interface SelectCategoryViewController : UITableViewController {
	Category *category;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	id <SelectCategoryViewControllerDelegate> delegate;
}

@property (nonatomic, assign) Category *category;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, assign) id <SelectCategoryViewControllerDelegate> delegate;

@end

@protocol SelectCategoryViewControllerDelegate
- (void)didUpdateCategory:(Category *)newCategory;
@end