//
//  AddSetViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddSetViewControllerDelegate;

@class DataSet, EditableTableViewCell;


@interface AddSetViewController : UITableViewController {
	id <AddSetViewControllerDelegate> delegate;
	
	DataSet *dataSet;
	EditableTableViewCell *nameCell;
}

@property (nonatomic, assign) id <AddSetViewControllerDelegate> delegate;

@property (nonatomic, retain) DataSet *dataSet;

@end


@protocol AddSetViewControllerDelegate
- (void)addSetViewController:(AddSetViewController *)controller didFinishWithSave:(BOOL)save;
@end