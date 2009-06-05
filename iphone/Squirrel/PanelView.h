//
//  PanelView.h
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataPanel, DataItem;

@protocol PanelViewDelegate;


@interface PanelView : UIView {
	DataPanel *dataPanel;
	
	id <PanelViewDelegate> delegate;
	
	BOOL rendered;
}

@property (nonatomic, assign) DataPanel *dataPanel;
@property (nonatomic, assign) BOOL rendered;

@property (nonatomic, assign) id <PanelViewDelegate> delegate;

@end


@protocol PanelViewDelegate
- (void)didBeginAddingNewDataEntryForView:(PanelView *)panelView forDataItem:(DataItem *)dataItem;
@end
