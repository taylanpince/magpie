//
//  PanelView.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PanelView.h"
#import "DataPanel.h"
#import "DataItem.h"
#import "DataSet.h"


@implementation PanelView

@synthesize dataPanel, delegate, rendered;


#define MAIN_FONT_SIZE 18

static UIFont *mainFont = nil;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        mainFont = [[UIFont boldSystemFontOfSize:MAIN_FONT_SIZE] retain];
		
		self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}


- (void)setDataPanel:(DataPanel *)aDataPanel {
	if (dataPanel != aDataPanel) {
		dataPanel = aDataPanel;
		
		[self layoutSubviews];
	}
}


- (void)layoutSubviews {
	if (rendered) return;
	NSLog(@"Called layoutSubviews");
	CGPoint point = CGPointMake(10.0, 10.0);
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, self.frame.size.width - 20.0, 20.0)];
	
	titleLabel.text = dataPanel.name;
	titleLabel.font = mainFont;
	titleLabel.backgroundColor = [UIColor lightGrayColor];
	
	[self addSubview:titleLabel];
	
	point.y += titleLabel.frame.size.height + 6.0;
	
	[titleLabel release];
	
    int counter = 0;
	
	for (DataItem *dataItem in dataPanel.dataSet.dataItems) {
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, self.frame.size.width - 20.0, 20.0)];
		
		titleLabel.text = dataItem.name;
		titleLabel.font = mainFont;
		titleLabel.backgroundColor = [UIColor lightGrayColor];
		
		[self addSubview:titleLabel];
		
		UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
		
		addButton.frame = CGRectMake(point.x + 200.0, point.y, 10.0, 10.0);
		addButton.tag = counter;
		
		[addButton addTarget:self action:@selector(didTouchAddButton:) forControlEvents:UIControlEventTouchDown];
		[self addSubview:addButton];
		
		point.y += titleLabel.frame.size.height + 6.0;
		
		[titleLabel release];
		
		CALayer *aLayer = [CALayer layer];
		
		aLayer.anchorPoint = CGPointMake(0.0, 0.0);
		aLayer.frame = CGRectMake(point.x, point.y, 0.0, 20.0);
		aLayer.backgroundColor = [[UIColor blackColor] CGColor];
		
		[self.layer addSublayer:aLayer];
		
		CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];

		resizeAnimation.duration = 1.0;
		resizeAnimation.removedOnCompletion = NO;
		resizeAnimation.fillMode = kCAFillModeForwards;
		resizeAnimation.toValue = [NSNumber numberWithFloat:((self.frame.size.width - 20.0) * dataItem.percentage / 100.0)];
		resizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

		[aLayer addAnimation:resizeAnimation forKey:@"animateWidth"];
		
		point.y += aLayer.bounds.size.height + 6.0;
		
		counter++;
	}
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, point.y);
	
	rendered = YES;
}


- (void)didTouchAddButton:(id)sender {
	UIButton *addButton = (UIButton *)sender;
	DataItem *dataItem = [dataPanel.dataSet.dataItems objectAtIndex:addButton.tag];
	
	[delegate didBeginAddingNewDataEntryForView:self forDataItem:dataItem];
}


- (void)dealloc {
    [super dealloc];
}


@end
