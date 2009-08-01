//
//  SelectDataSetViewController.h
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@protocol SelectDataSetViewControllerDelegate;

@class DataSet;


@interface SelectDataSetViewController : UITableViewController {
	DataSet *dataSet;
	
	id <SelectDataSetViewControllerDelegate> delegate;
}

@property (nonatomic, assign) DataSet *dataSet;

@property (nonatomic, assign) id <SelectDataSetViewControllerDelegate> delegate;

@end


@protocol SelectDataSetViewControllerDelegate
- (void)didUpdateDataSet:(DataSet *)newDataSet;
@end
