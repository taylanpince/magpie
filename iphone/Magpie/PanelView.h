//
//  PanelView.h
//  Magpie
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

@class Display, Item;


@interface PanelView : UIView {
	Display *display;
	
	BOOL rendered;
}

@property (nonatomic, assign) Display *display;
@property (nonatomic, assign) BOOL rendered;

@end
