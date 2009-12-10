//
//  QuickEntryViewController.h
//  Magpie
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "KeyPadViewController.h"

@protocol QuickEntryViewControllerDelegate;

@class Entry, Item;

@interface QuickEntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, KeyPadViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	UIDatePicker *datePickerView;
	UIPickerView *dataSetPicker;
	
	KeyPadViewController *keyPad;
	Entry *entry;
	Item *item;
	
	NSManagedObjectContext *managedObjectContext;
	NSNumberFormatter *valueFormatter;
	NSDateFormatter *dateFormatter;
	NSInteger activeRow;
	
	IBOutlet UITableView *formTableView;
	
	id <QuickEntryViewControllerDelegate> delegate;
}

@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, retain) UIPickerView *dataSetPicker;

@property (nonatomic, retain) KeyPadViewController *keyPad;
@property (nonatomic, retain) Entry *entry;
@property (nonatomic, retain) Item *item;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSNumberFormatter *valueFormatter;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) NSInteger activeRow;

@property (nonatomic, retain) IBOutlet UITableView *formTableView;

@property (nonatomic, assign) id <QuickEntryViewControllerDelegate> delegate;

@end

@protocol QuickEntryViewControllerDelegate
- (void)didCloseQuickEntryView;
@end