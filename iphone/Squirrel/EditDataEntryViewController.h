//
//  EditDataEntryViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataEntry;


@interface EditDataEntryViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource> {
	UIPickerView *pickerView;
	UIDatePicker *datePickerView;
	DataEntry *dataEntry;
	
	IBOutlet UITableView *formTableView;
}

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIDatePicker *datePickerView;
@property (nonatomic, assign) DataEntry *dataEntry;

@property (nonatomic, retain) IBOutlet UITableView *formTableView;

@end
