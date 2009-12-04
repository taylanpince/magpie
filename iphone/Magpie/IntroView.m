//
//  IntroView.m
//  Magpie
//
//  Created by Taylan Pince on 09-10-05.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "IntroView.h"
#import "PanelColor.h"


@implementation IntroView

@synthesize delegate, type;

static UIFont *largeFont = nil;
static UIFont *boldFont = nil;
static UIFont *standardFont = nil;
static UIFont *smallFont = nil;

static UIColor *darkColor = nil;
static UIColor *lightColor = nil;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
		[self setOpaque:YES];
		[self setBackgroundColor:[UIColor whiteColor]];
		[self setType:0];
		
		largeFont = [UIFont systemFontOfSize:32.0];
		boldFont = [UIFont boldSystemFontOfSize:14.0];
		standardFont = [UIFont systemFontOfSize:14.0];
		smallFont = [UIFont systemFontOfSize:12.0];
		
		darkColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.0];
		lightColor = [UIColor colorWithRed:0.41 green:0.41 blue:0.41 alpha:1.0];
    }

    return self;
}


- (void)drawRect:(CGRect)rect {
	switch (type) {
		case 1:
			[darkColor set];
			[@"Welcome to Magpie" drawInRect:CGRectMake(15.0, 15.0, 290.0, 50.0) withFont:largeFont lineBreakMode:UILineBreakModeTailTruncation];
			[@"Before you start, let us give you a brief overview of what you can accomplish with Magpie, and how you can do it." drawInRect:CGRectMake(15.0, 65.0, 290.0, 400.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			[@"COLLECT AND DISPLAY" drawInRect:CGRectMake(95.0, 143.0, 210.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation];
			[@"Magpie lets you easily collect any kind of data, and track it over time using beautiful graphics." drawInRect:CGRectMake(95.0, 162.0, 210.0, 250.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			[@"Possibilities are endless – you could visualize your exercise routines, music genres that you most listen to, or your favorite sports team’s scores." drawInRect:CGRectMake(95.0, 228.0, 210.0, 250.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			[@"As an example, let’s say you wanted to track your caffeine consumption in several graphs, over time, and by type." drawInRect:CGRectMake(95.0, 328.0, 210.0, 250.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			
			[lightColor set];
			[@"Swipe left to continue. Tap anywhere to go back." drawInRect:CGRectMake(15.0, 412.0, 290.0, 20.0) withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
			
			CGContextRef context = UIGraphicsGetCurrentContext();
			UIColor *panelColor = [PanelColor colorWithName:@"Blue" alpha:1.0];
			
			CGFloat radius = 30.0;
			CGPoint center = CGPointMake(50.0, 182.0);
			
			CGContextSetFillColorWithColor(context, [panelColor CGColor]);
			CGContextMoveToPoint(context, center.x, center.y);
			CGContextAddLineToPoint(context, center.x + (radius *  (M_PI / 180.0) * 20.0), center.y + (radius * sin((M_PI / 180.0) * 20.0)));
			CGContextMoveToPoint(context, center.x, center.y);
			CGContextAddArc(context, center.x, center.y, radius, (M_PI / 180.0) * 20.0, (M_PI / 180.0) * 300.0, 0);
			CGContextAddLineToPoint(context, center.x, center.y);
			CGContextClosePath(context);
			CGContextFillPath(context);
			
			CGContextSetFillColorWithColor(context, [[panelColor colorWithAlphaComponent:0.5] CGColor]);
			CGContextMoveToPoint(context, center.x, center.y);
			CGContextAddLineToPoint(context, center.x + (radius * cos((M_PI / 180.0) * 295.0)), center.y + (radius * sin((M_PI / 180.0) * 295.0)));
			CGContextMoveToPoint(context, center.x, center.y);
			CGContextAddArc(context, center.x, center.y, radius, (M_PI / 180.0) * 300.0, (M_PI / 180.0) * 380.0, 0);
			CGContextAddLineToPoint(context, center.x, center.y);
			CGContextClosePath(context);
			CGContextFillPath(context);
			break;
		case 2:
			[darkColor set];
			[@"CATEGORIES" drawInRect:CGRectMake(15.0, 15.0, 210.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation];
			[@"A Category is a group of Items, used for collecting all your data under a single umbrella. For this example, we should start by creating a “Caffeine” category." drawInRect:CGRectMake(15.0, 32.0, 210.0, 250.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			[@"ITEMS" drawInRect:CGRectMake(15.0, 143.0, 210.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation];
			[@"Items can be anything that you would like to count. For instance, under the Caffeine category, you can add Espresso, Macchiatto and Cappuccino." drawInRect:CGRectMake(15.0, 159.0, 210.0, 250.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			[@"ENTRIES" drawInRect:CGRectMake(15.0, 270.0, 210.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation];
			[@"An entry is a time stamped value attached to an Item. Entries let you track values per Item over time – you can add as many as you like." drawInRect:CGRectMake(15.0, 288.0, 210.0, 250.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];

			[lightColor set];
			[@"Swipe left to continue. Tap anywhere to go back." drawInRect:CGRectMake(15.0, 412.0, 290.0, 20.0) withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
			break;
		case 3:
			[darkColor set];
			[@"DISPLAYS" drawInRect:CGRectMake(95.0, 15.0, 210.0, 20.0) withFont:boldFont lineBreakMode:UILineBreakModeTailTruncation];
			[@"A Display represents a specific Category using the chosen graph type and color. You can use a myriad of graphs, from pie charts to total amount outputs." drawInRect:CGRectMake(95.0, 32.0, 210.0, 250.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			[@"To illustrate the caffeine data, we could add a pie chart display that would visualize different types, as well as a daily graph that renders consumption over time." drawInRect:CGRectMake(95.0, 134.0, 210.0, 250.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			[@"Now that you have a general understanding of the basic concepts behind Magpie, you can follow the in-app tutorial bubbles to create your first Category and Display, and start adding Entries." drawInRect:CGRectMake(15.0, 239.0, 290.0, 400.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];
			[@"You can always come back to this introduction by tapping on the Magpie logo under the main screen." drawInRect:CGRectMake(15.0, 340.0, 290.0, 400.0) withFont:standardFont lineBreakMode:UILineBreakModeWordWrap];

			[lightColor set];
			[@"Tap anywhere to continue." drawInRect:CGRectMake(15.0, 412.0, 290.0, 20.0) withFont:smallFont lineBreakMode:UILineBreakModeTailTruncation];
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
