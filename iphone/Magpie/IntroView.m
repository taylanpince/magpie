//
//  IntroView.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-05.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "IntroView.h"


@implementation IntroView

@synthesize delegate, type;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
		[self setOpaque:YES];
		[self setBackgroundColor:[UIColor whiteColor]];
		[self setType:0];
    }

    return self;
}


- (void)drawRect:(CGRect)rect {
	switch (type) {
		case 0:
			[@"1" drawInRect:CGRectMake(10.0, 10.0, 100.0, 100.0) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeWordWrap];
			break;
		case 1:
			[@"2" drawInRect:CGRectMake(10.0, 10.0, 100.0, 100.0) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeWordWrap];
			break;
		case 2:
			[@"3" drawInRect:CGRectMake(10.0, 10.0, 100.0, 100.0) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeWordWrap];
			break;
		default:
			break;
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[delegate didTapIntroView:self];
}


- (void)dealloc {
    [super dealloc];
}

@end
