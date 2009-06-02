//
//  PanelView.h
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class DataPanel;


@interface PanelView : UIView {
	DataPanel *dataPanel;
}

@property (nonatomic, assign) DataPanel *dataPanel;

@end
