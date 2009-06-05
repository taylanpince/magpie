//
//  EditDataEntryViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "KeyPadViewController.h"

@class DataEntry, DataItem, KeyPadViewController;


@interface EditDataEntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, KeyPadViewControllerDelegate> {
	UIDatePicker *datePickerView;
	KeyPadViewController *keyPad;
	DataEntry *dataEntry;
	DataItem *dataItem;
	NSNumber *dataEntryValue;
	NSNumberFormatter *valueFormatter;
	NSDate *dataEntryTimeStamp;
	NSDateFormatter *dateFormatter;
	
	IBOutlet UITableView *formTableView;
}

@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, retain) KeyPadViewController *keyPad;
@property (nonatomic, retain) DataEntry *dataEntry;
@property (nonatomic, retain) DataItem *dataItem;
@property (nonatomic, retain) NSNumber *dataEntryValue;
@property (nonatomic, retain) NSNumberFormatter *valueFormatter;
@property (nonatomic, retain) NSDate *dataEntryTimeStamp;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

@property (nonatomic, retain) IBOutlet UITableView *formTableView;

@end
