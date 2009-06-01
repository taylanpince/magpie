//
//  DataPanelViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "EditableTableViewCell.h"

@class DataPanel;


@interface DataPanelViewController : UITableViewController <EditableTableViewCellDelegate> {
	DataPanel *dataPanel;
	NSMutableString *dataPanelName;
	UITextField *activeTextField;
}

@property (nonatomic, retain) DataPanel *dataPanel;
@property (nonatomic, retain) NSMutableString *dataPanelName;
@property (nonatomic, assign) UITextField *activeTextField;

@end
