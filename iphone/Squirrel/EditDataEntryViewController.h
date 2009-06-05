//
//  EditDataEntryViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "KeyPadViewController.h"

@class DataEntry, KeyPadViewController;


@interface EditDataEntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, KeyPadViewControllerDelegate> {
	UIDatePicker *datePickerView;
	KeyPadViewController *keyPad;
	DataEntry *dataEntry;
	NSMutableString *dataEntryValue;
	NSDate *dataEntryTimeStamp;
	
	IBOutlet UITableView *formTableView;
}

@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, retain) KeyPadViewController *keyPad;
@property (nonatomic, retain) DataEntry *dataEntry;
@property (nonatomic, retain) NSMutableString *dataEntryValue;
@property (nonatomic, retain) NSDate *dataEntryTimeStamp;

@property (nonatomic, retain) IBOutlet UITableView *formTableView;

@end
