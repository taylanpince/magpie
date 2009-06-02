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


@interface PanelView (PrivateMethods)
- (void)setupSubLayers;
@end


@implementation PanelView

@synthesize dataPanel;


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
		
		[self setupSubLayers];
	}
}


- (void)setupSubLayers {
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
		resizeAnimation.toValue = [NSNumber numberWithFloat:((counter + 1) * 50.0)];
		resizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		
		[aLayer addAnimation:resizeAnimation forKey:@"animateWidth"];
		
		point.y += aLayer.bounds.size.height + 6.0;
		
		counter++;
	}
}


//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//	UIColor *backgroundColor = [UIColor lightGrayColor];
//	UIColor *labelColor = [UIColor blackColor];
//	
//	[backgroundColor set];
//	
//	CGContextFillRect(context, rect);
//
//	CGPoint point = CGPointMake(rect.origin.x + 10.0, rect.origin.y + 10.0);
//	
//	[labelColor set];
//	
//	CGSize drawnSize = [dataPanel.name drawInRect:CGRectMake(point.x, point.y, rect.size.width, 600.0f) withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
//	
//	point.y += drawnSize.height + 6.0;
//	
//	int counter = 0;
//	
//	for (DataItem *dataItem in dataPanel.dataSet.dataItems) {
//		CGSize drawnSize = [dataItem.name drawInRect:CGRectMake(point.x, point.y, rect.size.width, 600.0f) withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
//		
//		point.y += drawnSize.height;
//		
////		CGRect drawnRect = CGRectMake(point.x, point.y, ((counter + 1) * 50.0), 10.0);
////		CGContextFillRect(context, drawnRect);
////		
////		point.y += drawnRect.size.height + 6.0;
//		
//		CALayer *aLayer = [CALayer layer];
//		
//		aLayer.bounds = CGRectMake(point.x, point.y, ((counter + 1) * 50.0), 10.0);
//		aLayer.backgroundColor = [[UIColor blueColor] CGColor];
////		aLayer.delegate = self;
//		
//		[(CALayer *)[self layer] addSublayer:aLayer];
//		[aLayer release];
//		
//		counter++;
//	}
//}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	NSLog(@"Draw Layer");
}


- (void)dealloc {
    [super dealloc];
}


@end
