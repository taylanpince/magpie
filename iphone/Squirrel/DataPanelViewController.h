//
//  DataPanelViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EditableTableViewCell.h"
#import "SelectDataSetViewController.h"
#import "SelectPanelTypeViewController.h"

@class DataPanel, DataSet;


@interface DataPanelViewController : UITableViewController <EditableTableViewCellDelegate, SelectDataSetViewControllerDelegate, SelectPanelTypeViewControllerDelegate> {
	DataPanel *dataPanel;
	NSMutableString *dataPanelName;
	NSMutableString *dataPanelType;
	DataSet *dataPanelSet;
	UITextField *activeTextField;
}

@property (nonatomic, retain) DataPanel *dataPanel;
@property (nonatomic, retain) NSMutableString *dataPanelName;
@property (nonatomic, retain) NSMutableString *dataPanelType;
@property (nonatomic, assign) DataSet *dataPanelSet;
@property (nonatomic, assign) UITextField *activeTextField;

@end
