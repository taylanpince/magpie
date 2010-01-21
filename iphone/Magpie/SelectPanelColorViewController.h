//
//  SelectPanelColorViewController.h
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@protocol SelectPanelColorViewControllerDelegate;

@interface SelectPanelColorViewController : UITableViewController {
	NSString *panelColor;
	NSArray *panelColors;
	
	id <SelectPanelColorViewControllerDelegate> delegate;
}

@property (nonatomic, assign) NSString *panelColor;
@property (nonatomic, retain) NSArray *panelColors;

@property (nonatomic, assign) id <SelectPanelColorViewControllerDelegate> delegate;

@end

@protocol SelectPanelColorViewControllerDelegate
- (void)didUpdatePanelColor:(NSMutableString *)newPanelColor;
@end