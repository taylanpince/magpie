//
//  EditSetViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataSet, EditableTableViewCell;


@interface EditSetViewController : UITableViewController {
	DataSet *dataSet;
	EditableTableViewCell *nameCell;
}

@property (nonatomic, retain) DataSet *dataSet;

@end
