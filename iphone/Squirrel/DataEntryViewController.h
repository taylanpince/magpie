//
//  DataEntryViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@protocol DataEntryViewControllerDelegate;

@class DataItem;


@interface DataEntryViewController : UITableViewController {
	DataItem *dataItem;
	NSDateFormatter *dateFormatter;
	NSNumberFormatter *valueFormatter;
	
	id <DataEntryViewControllerDelegate> delegate;
}

@property (nonatomic, retain) DataItem *dataItem;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSNumberFormatter *valueFormatter;

@property (nonatomic, assign) id <DataEntryViewControllerDelegate> delegate;

@end


@protocol DataEntryViewControllerDelegate
- (void)didCloseDataEntryView;
@end
