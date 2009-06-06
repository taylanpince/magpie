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


#define SMALL_FONT_SIZE 12
#define MAIN_FONT_SIZE 18

static UIFont *smallFont = nil;
static UIFont *mainFont = nil;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		smallFont = [[UIFont systemFontOfSize:SMALL_FONT_SIZE] retain];
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

	CGPoint point = CGPointMake(10.0, 10.0);
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, self.frame.size.width - 20.0, 20.0)];
	
	titleLabel.text = dataPanel.name;
	titleLabel.font = smallFont;
	titleLabel.textAlignment = UITextAlignmentRight;
	titleLabel.backgroundColor = [UIColor lightGrayColor];
	
	[self addSubview:titleLabel];
	
	point.y += titleLabel.frame.size.height + 6.0;
	
	[titleLabel release];
	
    int counter = 0;
	
	for (DataItem *dataItem in dataPanel.dataSet.dataItems) {
		CGSize titleSize = [dataItem.name sizeWithFont:mainFont];
		UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		[titleButton setTitle:dataItem.name forState:UIControlStateNormal];
		[titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[titleButton addTarget:self action:@selector(didTouchAddButton:) forControlEvents:UIControlEventTouchUpInside];
		
		titleButton.frame = CGRectMake(point.x, point.y, titleSize.width, titleSize.height);
		titleButton.font = mainFont;
		titleButton.tag = counter;
		
		[self addSubview:titleButton];
		
		UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		[editButton setImage:[UIImage imageNamed:@"cog.png"] forState:UIControlStateNormal];
		
		editButton.frame = CGRectMake(point.x + titleSize.width + 5.0, point.y + 3.0, 16.0, 16.0);
		editButton.tag = counter;
		
		[editButton addTarget:self action:@selector(didTouchAddButton:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:editButton];
		
		point.y += titleButton.frame.size.height + 6.0;
		
		CALayer *barLayer = [CALayer layer];
		
		barLayer.anchorPoint = CGPointMake(0.0, 0.0);
		barLayer.frame = CGRectMake(point.x, point.y, 0.0, 20.0);
		barLayer.backgroundColor = [[UIColor blackColor] CGColor];
		
		CALayer *barBGLayer = [CALayer layer];
		
		barBGLayer.frame = CGRectMake(point.x, point.y, self.frame.size.width - 20.0, 20.0);
		barBGLayer.backgroundColor = [[UIColor darkGrayColor] CGColor];
		
		[self.layer addSublayer:barBGLayer];
		[self.layer addSublayer:barLayer];
		
		CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];

		resizeAnimation.duration = 1.0;
		resizeAnimation.removedOnCompletion = NO;
		resizeAnimation.fillMode = kCAFillModeForwards;
		resizeAnimation.toValue = [NSNumber numberWithFloat:((self.frame.size.width - 20.0) * dataItem.percentage / 100.0)];
		resizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

		[barLayer addAnimation:resizeAnimation forKey:@"animateWidth"];
		
		point.y += barLayer.bounds.size.height + 6.0;
		
		counter++;
	}
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, point.y + 4.0);
	
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
