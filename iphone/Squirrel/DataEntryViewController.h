//
//  DataEntryViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataItem;


@interface DataEntryViewController : UITableViewController {
	DataItem *dataItem;
	NSDateFormatter *dateFormatter;
	NSNumberFormatter *valueFormatter;
}

@property (nonatomic, retain) DataItem *dataItem;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSNumberFormatter *valueFormatter;

@end
