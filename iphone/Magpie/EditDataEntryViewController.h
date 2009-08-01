//
//  EditDataEntryViewController.h
//  Magpie
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "KeyPadViewController.h"

@protocol EditDataEntryViewControllerDelegate;

@class DataEntry, DataItem, KeyPadViewController;


@interface EditDataEntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, KeyPadViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	UIDatePicker *datePickerView;
	UIPickerView *dataSetPicker;
	KeyPadViewController *keyPad;
	DataEntry *dataEntry;
	DataItem *dataItem;
	NSNumber *dataEntryValue;
	NSNumberFormatter *valueFormatter;
	NSDate *dataEntryTimeStamp;
	NSDateFormatter *dateFormatter;
	NSInteger activeRow;
	
	IBOutlet UITableView *formTableView;
	
	id <EditDataEntryViewControllerDelegate> delegate;
}

@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, retain) UIPickerView *dataSetPicker;
@property (nonatomic, retain) KeyPadViewController *keyPad;
@property (nonatomic, retain) DataEntry *dataEntry;
@property (nonatomic, retain) DataItem *dataItem;
@property (nonatomic, retain) NSNumber *dataEntryValue;
@property (nonatomic, retain) NSNumberFormatter *valueFormatter;
@property (nonatomic, retain) NSDate *dataEntryTimeStamp;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) NSInteger activeRow;

@property (nonatomic, retain) IBOutlet UITableView *formTableView;

@property (nonatomic, assign) id <EditDataEntryViewControllerDelegate> delegate;

@end


@protocol EditDataEntryViewControllerDelegate
- (void)didCloseEditDataEntryView;
@end
