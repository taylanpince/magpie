//
//  PanelView.h
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataPanel, DataItem;


@interface PanelView : UIView {
	DataPanel *dataPanel;
	
	BOOL rendered;
}

@property (nonatomic, assign) DataPanel *dataPanel;
@property (nonatomic, assign) BOOL rendered;

@end
