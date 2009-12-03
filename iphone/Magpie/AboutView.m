//
//  AboutView.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-06.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "AboutView.h"

@implementation AboutView

@synthesize delegate;

static UIFont *largeFont = nil;
static UIFont *smallFont = nil;

static UIColor *darkColor = nil;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
		[self setOpaque:YES];
		[self setBackgroundColor:[UIColor whiteColor]];
		
		largeFont = [UIFont systemFontOfSize:14.0];
		smallFont = [UIFont systemFontOfSize:12.0];
		
		darkColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.0];
    }
	
    return self;
}


- (void)drawRect:(CGRect)rect {
	[[UIImage imageNamed:@"logo.png"] drawInRect:CGRectMake(110.0, 25.0, 100.0, 100.0)];
	
	[darkColor set];
	[@"Magpie v0.5.1ß\nby Hippo Foundry →" drawInRect:CGRectMake(15.0, 130.0, 290.0, 60.0) withFont:smallFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];

	[@"Magpie is a personal statistics tool. It lets you track any kind of numerical data, whether it is your weekly exercise stats, daily expenses, or the music genres that you listen to." drawInRect:CGRectMake(15.0, 190.0, 290.0, 300.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
	[@"You can quickly enter new data, and visualize the results in a myriad of graphs, from pie charts to total amount displays, or bar graphs that render the changes over time." drawInRect:CGRectMake(15.0, 280.0, 290.0, 300.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
	[@"For any questions about this app, contact us via support@hippofoundry.com →" drawInRect:CGRectMake(15.0, 370.0, 290.0, 300.0) withFont:largeFont lineBreakMode:UILineBreakModeWordWrap];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[delegate didTapAboutView:self];
}


- (void)dealloc {
    [super dealloc];
}

@end
