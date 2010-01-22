//
//  SelectPanelTypeViewController.h
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@protocol SelectPanelTypeViewControllerDelegate;

@interface SelectPanelTypeViewController : UITableViewController {
	NSString *panelType;
	NSArray *panelTypes;
	
	id <SelectPanelTypeViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSString *panelType;
@property (nonatomic, retain) NSArray *panelTypes;

@property (nonatomic, assign) id <SelectPanelTypeViewControllerDelegate> delegate;

@end

@protocol SelectPanelTypeViewControllerDelegate
- (void)didUpdatePanelType:(NSMutableString *)newPanelType;
@end