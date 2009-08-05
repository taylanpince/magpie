//
//  HelpView.h
//  Magpie
//
//  Created by Taylan Pince on 01/08/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

@interface HelpView : UIView {
	NSString *helpText;
	NSInteger helpBubbleCorner;
}

@property (nonatomic, retain) NSString *helpText;
@property (nonatomic, assign) NSInteger helpBubbleCorner;

@end
