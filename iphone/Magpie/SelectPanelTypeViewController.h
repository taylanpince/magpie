//
//  SelectPanelTypeViewController.h
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@protocol SelectPanelTypeViewControllerDelegate;


@interface SelectPanelTypeViewController : UITableViewController {
	NSMutableString *panelType;
	NSArray *panelTypes;
	
	id <SelectPanelTypeViewControllerDelegate> delegate;
}

@property (nonatomic, assign) NSMutableString *panelType;
@property (nonatomic, retain) NSArray *panelTypes;

@property (nonatomic, assign) id <SelectPanelTypeViewControllerDelegate> delegate;

@end


@protocol SelectPanelTypeViewControllerDelegate
- (void)didUpdatePanelType:(NSMutableString *)newPanelType;
@end
