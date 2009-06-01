//
//  DataSetViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 30/05/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EditableTableViewCell.h"

@class DataSet;


@interface DataSetViewController : UITableViewController <EditableTableViewCellDelegate> {
	DataSet *dataSet;
	NSMutableString *dataSetName;
	NSMutableArray *dataItems;
	NSMutableArray *deletedDataItems;
	UITextField *activeTextField;
	
	BOOL adding;
}

@property (nonatomic, retain) DataSet *dataSet;
@property (nonatomic, retain) NSMutableString *dataSetName;
@property (nonatomic, retain) NSMutableArray *dataItems;
@property (nonatomic, retain) NSMutableArray *deletedDataItems;
@property (nonatomic, assign) UITextField *activeTextField;

@end
