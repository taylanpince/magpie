//
//  HelpView.m
//  Magpie
//
//  Created by Taylan Pince on 01/08/09.
//  Copyright 2009 Hippo Foundry. All rights reserved.
//

#import "HelpView.h"


@implementation HelpView

@synthesize helpText, helpBubbleCorner;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setOpaque:NO];
		[self setBackgroundColor:[UIColor clearColor]];
		[self setHelpText:@""];
		[self setHelpBubbleCorner:1];
    }
    return self;
}

- (void)setHelpText:(NSString *)newHelpText {
	if (helpText != newHelpText) {
		[helpText release];
		
		helpText = [newHelpText retain];
		
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor darkGrayColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    CGRect rrect = [self bounds];
    
	CGFloat radius = 15.0;
    
    CGFloat minx = CGRectGetMinX(rrect) + 5.0f;
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect) - 10.0f;
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);

	CGPoint corner1, corner2, corner3;
	
	switch (helpBubbleCorner) {
		case 1:
			miny = miny + 20.0;
			maxy = maxy - 20.0;
			corner1 = CGPointMake(minx + 10.0, miny + 2.0);
			corner2 = CGPointMake(minx + 20.0, miny - 10.0);
			corner3 = CGPointMake(minx + 30.0, miny + 2.0);
			break;
		case 2:
			miny = miny + 20.0;
			maxy = maxy - 20.0;
			corner3 = CGPointMake(maxx - 10.0, miny + 2.0);
			corner2 = CGPointMake(maxx - 20.0, miny - 10.0);
			corner1 = CGPointMake(maxx - 30.0, miny + 2.0);
			break;
		case 3:
			maxy = maxy - 20.0;
			maxx = maxx - 5.0;
			corner1 = CGPointMake(maxx - 6.0, maxy - 4.0);
			corner2 = CGPointMake(maxx - 16.0, maxy + 10.0);
			corner3 = CGPointMake(maxx - 26.0, maxy - 4.0);
			break;
		case 4:
			maxy = maxy - 20.0;
			corner3 = CGPointMake(minx + 10.0, maxy - 2.0);
			corner2 = CGPointMake(minx + 20.0, maxy + 10.0);
			corner1 = CGPointMake(minx + 30.0, maxy - 2.0);
			break;
		default:
			break;
	}

	CGContextSaveGState(context);
	CGContextSetShadow(context, CGSizeMake(2.0, -8.0), 4.0);

	CGContextMoveToPoint(context, corner1.x, corner1.y);
	CGContextAddLineToPoint(context, corner2.x, corner2.y);
	CGContextAddLineToPoint(context, corner3.x, corner3.y);
	CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
	CGContextFillPath(context);
	
	CGContextRestoreGState(context);
	
	[[UIColor blackColor] set];
	
	[helpText drawInRect:CGRectMake(minx + 10.0, miny + 10.0, maxx - minx - 15.0, maxy - miny - 20.0) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeWordWrap];
}


- (void)dealloc {
	[helpText release];
    [super dealloc];
}


@end
