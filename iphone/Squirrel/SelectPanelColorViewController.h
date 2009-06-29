//
//  SelectPanelColorViewController.h
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@protocol SelectPanelColorViewControllerDelegate;


@interface SelectPanelColorViewController : UITableViewController {
	NSMutableString *panelColor;
	NSArray *panelColors;
	
	id <SelectPanelColorViewControllerDelegate> delegate;
}

@property (nonatomic, assign) NSMutableString *panelColor;
@property (nonatomic, retain) NSArray *panelColors;

@property (nonatomic, assign) id <SelectPanelColorViewControllerDelegate> delegate;

@end


@protocol SelectPanelColorViewControllerDelegate
- (void)didUpdatePanelColor:(NSMutableString *)newPanelColor;
@end
