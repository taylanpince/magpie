//
//  PanelView.m
//  Squirrel
//
//  Created by Taylan Pince on 01/06/09.
//  Copyright 2009 Taylan Pince. All rights reserved.
//

#import "PanelView.h"
#import "DataPanel.h"
#import "DataItem.h"
#import "DataSet.h"


@implementation PanelView

@synthesize dataPanel;


#define MAIN_FONT_SIZE 18

static UIFont *mainFont = nil;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        mainFont = [[UIFont boldSystemFontOfSize:MAIN_FONT_SIZE] retain];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor *backgroundColor = [UIColor lightGrayColor];
	UIColor *labelColor = [UIColor blackColor];
	
	[backgroundColor set];
	
	CGContextFillRect(context, rect);

	CGPoint point = CGPointMake(rect.origin.x + 10.0, rect.origin.y + 10.0);
	
	[labelColor set];
	
	CGSize drawnSize = [dataPanel.name drawInRect:CGRectMake(point.x, point.y, rect.size.width, 600.0f) withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
	
	point.y += drawnSize.height + 6.0;
	
	int counter = 0;
	
	for (DataItem *dataItem in dataPanel.dataSet.dataItems) {
		CGSize drawnSize = [dataItem.name drawInRect:CGRectMake(point.x, point.y, rect.size.width, 600.0f) withFont:mainFont lineBreakMode:UILineBreakModeTailTruncation];
		
		point.y += drawnSize.height;
		
		CGRect drawnRect = CGRectMake(point.x, point.y, ((counter + 1) * 50.0), 10.0);
		CGContextFillRect(context, drawnRect);
		
		point.y += drawnRect.size.height + 6.0;
		
		counter++;
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
