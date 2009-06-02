//
//  EditDataEntryViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 02/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataEntry;


@interface EditDataEntryViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource> {
	DataEntry *dataEntry;
}

@property (nonatomic, assign) DataEntry *dataEntry;

@end
